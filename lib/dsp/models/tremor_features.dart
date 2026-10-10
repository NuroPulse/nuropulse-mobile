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

  /// RMS in the tremor band, m/s², matches the Python reference exactly
  /// (tools/python/nuropulse_reference.py in biomarker_demo), so golden
  /// tests compare like for like.
  final double bandRms;
  final double consistency;
}
