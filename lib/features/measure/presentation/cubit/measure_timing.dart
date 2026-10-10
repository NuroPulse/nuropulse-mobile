/// Countdown and live-tick timing for one recording
class MeasureTiming {
  const MeasureTiming({
    this.countdownSeconds = 3,
    this.countdownTick = const Duration(seconds: 1),
    this.liveTick = const Duration(milliseconds: 100),
  });

  final int countdownSeconds;
  final Duration countdownTick;

  /// About 10 updates per second, so the main thread does not slow sensor
  /// delivery.
  final Duration liveTick;
}
