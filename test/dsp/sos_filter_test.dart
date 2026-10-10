import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuropulse/dsp/stages/sos_filter.dart';

import 'support/test_support.dart';

Float64List _sine(int n, double fs, double freq, double amp) {
  return Float64List.fromList([
    for (var i = 0; i < n; i++) amp * math.sin(2 * math.pi * freq * i / fs),
  ]);
}

double _maxAbs(Float64List x, int from, int to) {
  var m = 0.0;
  for (var i = from; i < to; i++) {
    m = math.max(m, x[i].abs());
  }
  return m;
}

void main() {
  final sos = loadShippedConfig().bandpassSos;
  const fs = 50.0;
  const n = 1000; // 20 s
  // Ignore the first and last 3 s, where the filter is still settling.
  const from = 150;
  const to = n - 150;

  test('removes a constant offset', () {
    final constant = Float64List.fromList(List.filled(n, 5.0));

    final out = SosFilter.filtfilt(constant, sos);

    expect(_maxAbs(out, 0, n), lessThan(1e-6));
  });

  test('keeps a 5 Hz tone inside the pass band', () {
    final tone = _sine(n, fs, 5.0, 1.0);

    final out = SosFilter.filtfilt(tone, sos);

    // Forward-backward filtering squares the magnitude response, so the 5 Hz
    // gain is about 0.95 here. The value matches scipy.signal.sosfiltfilt.
    expect(_maxAbs(out, from, to), closeTo(0.9510, 0.001));
  });

  test('attenuates a 0.2 Hz drift well below the pass band', () {
    final drift = _sine(n, fs, 0.2, 1.0);

    final out = SosFilter.filtfilt(drift, sos);

    expect(_maxAbs(out, from, to), lessThan(0.01));
  });

  test('keeps the output length equal to the input length', () {
    final tone = _sine(n, fs, 5.0, 1.0);

    expect(SosFilter.filtfilt(tone, sos), hasLength(n));
  });

  test('rejects signals too short to pad', () {
    final tiny = Float64List(10);

    expect(() => SosFilter.filtfilt(tiny, sos), throwsArgumentError);
  });
}
