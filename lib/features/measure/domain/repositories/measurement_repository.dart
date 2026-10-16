import 'package:nuropulse/features/measure/domain/entity/live_window.dart';
import 'package:nuropulse/features/measure/domain/entity/measure_outcome.dart';
import 'package:nuropulse/features/measure/domain/entity/measurement_record.dart';

/// Records the user-accelerometer stream, analyzes it, and saves the result.
abstract class MeasurementRepository {
  /// Starts the sensor listener and keeps the screen awake. [duration] is
  /// the user's chosen recording length, kept for `duration_s` later.
  /// Throws [SensorFailure] if the sensor cannot start.
  Future<void> startRecording(Duration duration);

  /// Latest [samples] of user acceleration, for the live waveform only.
  LiveWindow liveWindow(int samples);

  /// Stops the listener and discards the buffer. Does not analyze or save.
  Future<void> cancelRecording();

  /// Stops, runs the DSP off the UI isolate, saves the measurement locally,
  /// and attempts an upload — a failed upload does not throw (see
  /// [NetworkFailure]). Throws [SensorFailure], [AnalysisFailure], or
  /// [StorageFailure].
  Future<MeasureOutcome> finishRecording();

  /// All saved measurements, most recent first. Throws [StorageFailure].
  Future<List<MeasurementRecord>> getMeasurements();

  /// Retries uploading every locally-saved measurement still marked
  /// `uploaded = false`. If the user is now signed in and a measurement was
  /// saved while signed out, it uploads under the current account instead
  /// of staying anonymous. Never throws; failures just stay pending for the
  /// next retry (CLAUDE.md section 9 step 4). Call at app start and after
  /// login.
  Future<void> retryPendingUploads();

  /// Attaches measurements that already uploaded anonymously (before this
  /// account existed) to the now signed-in account, via `claim_measurements`
  /// (CLAUDE.md section 4). Never throws. Call once right after login or
  /// registration succeeds.
  Future<void> claimAnonymousMeasurements();
}
