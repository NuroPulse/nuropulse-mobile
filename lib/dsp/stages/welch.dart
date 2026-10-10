import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fftea/fftea.dart';

import 'package:nuropulse/dsp/models/spectrum.dart';

/// One-sided Welch PSD. Matches scipy.signal.welch with the settings in
/// CLAUDE.md section 7: Hann window, constant detrend, density scaling,
/// mean averaging over segments.
class Welch {
  const Welch._();

  static Spectrum compute(
    Float64List x, {
    required double fs,
    required int segmentLength,
    required int overlap,
    required int nfft,
  }) {
    final window = _periodicHann(segmentLength);
    var windowPowerSum = 0.0;
    for (final w in window) {
      windowPowerSum += w * w;
    }
    final scale = 1 / (fs * windowPowerSum);

    final bins = nfft ~/ 2 + 1;
    final power = Float64List(bins);
    final fft = FFT(nfft);
    final step = segmentLength - overlap;
    var segments = 0;

    for (var start = 0; start + segmentLength <= x.length; start += step) {
      var mean = 0.0;
      for (var i = 0; i < segmentLength; i++) {
        mean += x[start + i];
      }
      mean /= segmentLength;

      // Zero-padding to nfft matches scipy's default, which pads the windowed
      // segment at the end.
      final buffer = List<double>.filled(nfft, 0.0);
      for (var i = 0; i < segmentLength; i++) {
        buffer[i] = (x[start + i] - mean) * window[i];
      }

      final spectrum = fft.realFft(buffer).discardConjugates();
      for (var k = 0; k < bins; k++) {
        final re = spectrum[k].x;
        final im = spectrum[k].y;
        power[k] += re * re + im * im;
      }
      segments++;
    }

    if (segments == 0) {
      throw ArgumentError('Signal is shorter than one Welch segment');
    }

    final frequencies = Float64List(bins);
    final nyquistBin = nfft ~/ 2;
    for (var k = 0; k < bins; k++) {
      frequencies[k] = k * fs / nfft;
      var value = power[k] / segments * scale;
      // One-sided spectrum: every bin except DC and Nyquist carries the
      // energy of its negative-frequency mirror.
      if (k != 0 && k != nyquistBin) value *= 2;
      power[k] = value;
    }
    return Spectrum(frequencies: frequencies, power: power);
  }

  /// Periodic Hann window, the default of scipy.signal.get_window.
  static Float64List _periodicHann(int n) {
    final window = Float64List(n);
    for (var i = 0; i < n; i++) {
      window[i] = 0.5 - 0.5 * math.cos(2 * math.pi * i / n);
    }
    return window;
  }
}
