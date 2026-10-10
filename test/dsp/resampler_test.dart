import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuropulse/dsp/stages/resampler.dart';

import 'support/test_support.dart';

void main() {
  final config = loadShippedConfig();

  test('returns the target rate for jittered timestamps', () {
    final t = jitteredTimestamps(seconds: 20, seed: 4);
    final x = Float64List(t.length);

    final out = Resampler.toTargetRate(t, x, config);

    // 20 s at 50 Hz, within one sample.
    expect(out.length, closeTo(20 * 50, 2));
  });

  test('reproduces a linear ramp in the interior', () {
    final t = jitteredTimestamps(seconds: 20, seed: 5);
    final x = Float64List.fromList([
      for (final us in t) 2 * ((us - t[0]) / 1e6) + 1,
    ]);

    final out = Resampler.toTargetRate(t, x, config);

    for (var i = 100; i < out.length - 100; i++) {
      final expected = 2 * (i / 50) + 1;
      expect(out[i], closeTo(expected, 1e-3), reason: 'sample $i');
    }
  });
}
