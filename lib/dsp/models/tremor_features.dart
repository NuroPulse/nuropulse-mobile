class TremorFeatures {
  const TremorFeatures({
    required this.peakFrequencyHz,
    required this.bandPowerRatio,
    required this.snr,
    required this.bandRms,
    required this.consistency,
  });

  final double peakFrequencyHz;
  final double bandPowerRatio;
  final double snr;

  /// RMS in the tremor band, m/s² — matches the Python reference exactly
  /// (tools/python/nuropulse_reference.py in biomarker_demo), so golden
  /// tests compare like for like. Convert to g (divide by 9.80665) only when
  /// building the contract's `band_rms_g` payload field in the data layer,
  /// not here.
  final double bandRms;
  final double consistency;
}
