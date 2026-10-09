/// Sampling statistics measured from the real sensor timestamps.
class QcResult {
  const QcResult({
    required this.effectiveFsHz,
    required this.jitter,
    required this.maxGapMs,
    required this.monotonic,
  });

  final double effectiveFsHz;

  /// Standard deviation of the sample intervals divided by their mean.
  final double jitter;

  final double maxGapMs;

  /// False when timestamps repeat or go backwards. The rate is meaningless
  /// in that case, so the gates treat it as a failure.
  final bool monotonic;
}
