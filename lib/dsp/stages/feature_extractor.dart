import 'dart:math' as math;
import 'dart:typed_data';

import '../dsp_config.dart';
import '../models/spectrum.dart';
import '../models/tremor_features.dart';
import 'welch.dart';

class FeatureExtractor {
  const FeatureExtractor._();

  /// [spectrum] is the per-axis PSD summed over axes. [processedAxes] are the
  /// preprocessed signals, needed for the per-segment consistency feature.
  static TremorFeatures compute(
    Spectrum spectrum,
    List<Float64List> processedAxes,
    DspConfig config,
  ) {
    final f = spectrum.frequencies;
    final psd = spectrum.power;

    final (peakHz, peakIndex) = _peak(f, psd, config.peakSearchHz);
    final ratioRange = _bandIndices(f, config.ratioBandHz);
    final tremorRange = _bandIndices(f, config.tremorBandHz);
    final ratioPower = _integrate(f, psd, ratioRange);
    final tremorPower = _integrate(f, psd, tremorRange);

    return TremorFeatures(
      peakFrequencyHz: peakHz,
      bandPowerRatio: tremorPower / ratioPower,
      snr: psd[peakIndex] / _median(psd, ratioRange),
      bandRms: math.sqrt(tremorPower),
      consistency: _consistency(processedAxes, config),
    );
  }

  /// Argmax inside the peak-search band, refined by parabolic interpolation.
  static (double, int) _peak(
    Float64List f,
    Float64List psd,
    (double, double) band,
  ) {
    final (first, last) = _bandIndices(f, band);
    var k = first;
    for (var i = first + 1; i <= last; i++) {
      if (psd[i] > psd[k]) k = i;
    }

    var delta = 0.0;
    if (k > 0 && k < psd.length - 1) {
      final a = psd[k - 1];
      final b = psd[k];
      final c = psd[k + 1];
      final denom = a - 2 * b + c;
      if (denom != 0) delta = 0.5 * (a - c) / denom;
    }
    return (f[k] + delta * (f[1] - f[0]), k);
  }

  /// Inclusive index range of bins inside [band]. The grid is sorted, so the
  /// range is contiguous.
  static (int, int) _bandIndices(Float64List f, (double, double) band) {
    var first = -1;
    var last = -1;
    for (var i = 0; i < f.length; i++) {
      if (f[i] >= band.$1 && f[i] <= band.$2) {
        if (first < 0) first = i;
        last = i;
      }
    }
    if (first < 0) {
      throw StateError('No frequency bins inside band $band');
    }
    return (first, last);
  }

  /// Trapezoidal integral over an inclusive index range.
  static double _integrate(Float64List f, Float64List psd, (int, int) range) {
    final (first, last) = range;
    var total = 0.0;
    for (var i = first; i < last; i++) {
      total += (psd[i] + psd[i + 1]) / 2 * (f[i + 1] - f[i]);
    }
    return total;
  }

  static double _median(Float64List psd, (int, int) range) {
    final (first, last) = range;
    final values = Float64List.sublistView(psd, first, last + 1)..sort();
    final mid = values.length ~/ 2;
    if (values.length.isOdd) return values[mid];
    return (values[mid - 1] + values[mid]) / 2;
  }

  /// Fraction of Welch segments whose own summed-PSD peak falls in the tremor
  /// band. Segments follow the same length and overlap as the main spectrum.
  static double _consistency(List<Float64List> axes, DspConfig config) {
    final segment = config.segmentSamples;
    final step = segment - config.overlapSamples;
    final n = axes.first.length;
    var hits = 0;
    var segments = 0;

    for (var start = 0; start + segment <= n; start += step) {
      final spectra = [
        for (final axis in axes)
          Welch.compute(
            Float64List.sublistView(axis, start, start + segment),
            fs: config.targetFsHz,
            segmentLength: segment,
            overlap: 0,
            nfft: config.nfft,
          ),
      ];
      final summed = spectra.reduce((a, b) => a.plus(b));
      final (peakHz, _) = _peak(
        summed.frequencies,
        summed.power,
        config.peakSearchHz,
      );
      if (peakHz >= config.tremorBandHz.$1 &&
          peakHz <= config.tremorBandHz.$2) {
        hits++;
      }
      segments++;
    }

    if (segments == 0) return 0;
    return hits / segments;
  }
}
