part of 'failure.dart';

/// The sensor stream could not start, or failed mid-recording.
final class SensorFailure extends Failure {
  const SensorFailure(super.message);
}
