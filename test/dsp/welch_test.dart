import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuropulse/dsp/stages/welch.dart';

const _fs = 50.0;
const _nfft = 256;
const _segment = 200;
const _overlap = 100;

Float64List _sine(int n, double freq) {
  return Float64List.fromList([
    for (var i = 0; i < n; i++) math.sin(2 * math.pi * freq * i / _fs),
  ]);
}

void main() {
  test('peaks at the tone frequency within one bin width', () {
    final spectrum = Welch.compute(
      _sine(1000, 5.0),
      fs: _fs,
      segmentLength: _segment,
      overlap: _overlap,
      nfft: _nfft,
    );

    var peak = 0;
    for (var k = 1; k < spectrum.power.length; k++) {
      if (spectrum.power[k] > spectrum.power[peak]) peak = k;
    }
    final binWidth = _fs / _nfft;

    expect(spectrum.frequencies[peak], closeTo(5.0, binWidth));
  });

  test('returns one-sided frequencies from DC to Nyquist', () {
    final spectrum = Welch.compute(
      _sine(1000, 5.0),
      fs: _fs,
      segmentLength: _segment,
      overlap: _overlap,
      nfft: _nfft,
    );

    expect(spectrum.frequencies.length, _nfft ~/ 2 + 1);
    expect(spectrum.frequencies.first, 0);
    expect(spectrum.frequencies.last, closeTo(_fs / 2, 1e-9));
  });

  test('removes a constant offset before the transform', () {
    final constant = Float64List.fromList(List.filled(1000, 3.0));

    final spectrum = Welch.compute(
      constant,
      fs: _fs,
      segmentLength: _segment,
      overlap: _overlap,
      nfft: _nfft,
    );

    expect(spectrum.power.every((p) => p.abs() < 1e-18), isTrue);
  });

  test('throws when the signal is shorter than one segment', () {
    expect(
      () => Welch.compute(
        Float64List(50),
        fs: _fs,
        segmentLength: _segment,
        overlap: _overlap,
        nfft: _nfft,
      ),
      throwsArgumentError,
    );
  });
}
