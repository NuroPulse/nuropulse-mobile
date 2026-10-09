import 'dart:typed_data';

/// One-sided power spectral density on a frequency grid.
class Spectrum {
  const Spectrum({required this.frequencies, required this.power});

  final Float64List frequencies;
  final Float64List power;

  /// Sums PSD values bin by bin. Used to add per-axis spectra. Never add
  /// vector magnitudes of a zero-mean signal (CLAUDE.md section 7).
  Spectrum plus(Spectrum other) {
    final sum = Float64List(power.length);
    for (var i = 0; i < power.length; i++) {
      sum[i] = power[i] + other.power[i];
    }
    return Spectrum(frequencies: frequencies, power: sum);
  }
}
