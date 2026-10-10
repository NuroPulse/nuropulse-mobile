import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuropulse/dsp/models/spectrum.dart';
import 'package:nuropulse/dsp/stages/feature_extractor.dart';

import 'support/test_support.dart';

void main() {
  final config = loadShippedConfig(); // peakSearchHz is (3.0, 12.0)

  test('peak frequency stays inside peakSearchHz when the spectrum keeps '
      'rising past the search band edge (no real local peak there)', () {
    // 0-15 Hz at 1 Hz spacing. Power rises through the whole 3-12 Hz
    // search band and keeps rising past it, so the argmax *inside* the
    // band sits right at its edge (index 12, 12 Hz) with no genuine
    // local-peak shape (no a < b > c) on either side — exactly the case
    // that broke the old `k < psd.length - 1` bound, which let the
    // parabolic fit borrow a neighbor from *outside* the search band and
    // extrapolate wildly.
    final frequencies = Float64List.fromList([
      for (var hz = 0; hz <= 15; hz++) hz.toDouble(),
    ]);
    final power = Float64List.fromList([
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12.3, 13, 14, 15, //
    ]);
    final spectrum = Spectrum(frequencies: frequencies, power: power);

    final features = FeatureExtractor.compute(spectrum, [
      Float64List(0),
      Float64List(0),
      Float64List(0),
    ], config);

    expect(features.peakFrequencyHz, closeTo(12.0, 0.5));
  });

  test("compute() must not mutate the caller's spectrum", () {
    // Regression: _median used to sort a Float64List.sublistView of psd —
    // a *view*, not a copy — which silently reordered the real spectrum
    // in place. Anything that read the spectrum afterwards (the detail
    // screen's chart) then saw sorted garbage instead of the real shape,
    // even though the features computed from it were correct.
    final frequencies = Float64List.fromList([
      for (var hz = 0; hz <= 15; hz++) hz.toDouble(),
    ]);
    final power = Float64List.fromList([
      0.5, 3.0, 1.0, 4.0, 2.0, 9.0, 1.5, 12.3, 0.2, 6.0, //
      0.8, 5.0, 2.2, 7.0, 0.4, 3.3,
    ]);
    final before = Float64List.fromList(power);
    final spectrum = Spectrum(frequencies: frequencies, power: power);

    FeatureExtractor.compute(spectrum, [
      Float64List(0),
      Float64List(0),
      Float64List(0),
    ], config);

    expect(power, orderedEquals(before));
  });
}
