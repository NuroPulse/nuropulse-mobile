import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:nuropulse/dsp/dsp_config.dart';
import 'package:nuropulse/dsp/models/dsp_input.dart';

const _epochUs = 1790899200000000;

DspConfig loadShippedConfig() {
  final text = File('assets/config/dsp_config.json').readAsStringSync();
  return DspConfig.fromJson(jsonDecode(text) as Map<String, dynamic>);
}

/// Strictly increasing timestamps with uniform jitter around [periodUs].
Int64List jitteredTimestamps({
  required int seconds,
  int periodUs = 10000,
  int jitterUs = 1000,
  int seed = 0,
}) {
  final rng = math.Random(seed);
  final n = seconds * 1000000 ~/ periodUs + 1;
  final t = Int64List(n);
  t[0] = _epochUs;
  for (var i = 1; i < n; i++) {
    t[i] = t[i - 1] + periodUs + rng.nextInt(2 * jitterUs + 1) - jitterUs;
  }
  return t;
}

/// Tone on three axes with Gaussian noise, sampled at the given timestamps.
DspInput syntheticInput(
  Int64List tUs, {
  double? freqHz,
  double amp = 0.05,
  double noiseSd = 0.02,
  int seed = 0,
}) {
  final rng = math.Random(seed + 1000);
  final n = tUs.length;
  final t0 = tUs[0];

  Float64List axis(double weight) {
    final out = Float64List(n);
    for (var i = 0; i < n; i++) {
      final seconds = (tUs[i] - t0) / 1e6;
      final tone = freqHz == null
          ? 0.0
          : amp * math.sin(2 * math.pi * freqHz * seconds);
      out[i] = weight * tone + noiseSd * _gaussian(rng);
    }
    return out;
  }

  return DspInput(tUs: tUs, x: axis(0.8), y: axis(0.5), z: axis(0.3));
}

double _gaussian(math.Random rng) {
  final u1 = rng.nextDouble() + 1e-12;
  final u2 = rng.nextDouble();
  return math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
}
