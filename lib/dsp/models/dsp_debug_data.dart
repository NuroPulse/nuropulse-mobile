import 'dart:typed_data';

import 'package:nuropulse/dsp/models/spectrum.dart';

/// Intermediate results kept for the debug views (CLAUDE.md section 9).
/// Only produced for the live result screen. Saved sessions do not store it.
class DspDebugData {
  const DspDebugData({
    required this.rawX,
    required this.filteredX,
    required this.spectrum,
  });

  /// Demeaned, resampled X axis, after the dropped edge, before the band-pass.
  final Float64List rawX;

  /// Same window after the band-pass.
  final Float64List filteredX;

  /// Summed PSD across axes.
  final Spectrum spectrum;
}
