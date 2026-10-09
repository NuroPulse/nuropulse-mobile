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
  final double bandRms;
  final double consistency;
}
