import 'package:nuropulse/features/measure/domain/entity/live_window.dart';
import 'package:nuropulse/features/measure/domain/entity/measure_outcome.dart';

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
}
