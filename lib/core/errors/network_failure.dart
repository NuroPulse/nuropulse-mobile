part of 'failure.dart';

/// Uploading a measurement failed (offline, server error, ...).
///
/// [MeasurementRepository.finishRecording] must catch this internally and
/// keep the measurement queued locally — a failed upload never turns a
/// valid result into a failure state (CLAUDE.md section 11).
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
