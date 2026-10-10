import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';
import 'package:nuropulse/features/measure/domain/entity/invalid_reason.dart';
import 'package:nuropulse/features/measure/domain/entity/live_window.dart';

part 'measure_state.freezed.dart';

/// idle | countdown | recording | processing | success | invalid | failure.
@freezed
sealed class MeasureState with _$MeasureState {
  const factory MeasureState.idle() = MeasureIdle;

  const factory MeasureState.countdown(int secondsLeft) = MeasureCountdown;

  const factory MeasureState.recording({
    required Duration elapsed,
    required LiveWindow window,
  }) = MeasureRecording;

  const factory MeasureState.processing() = MeasureProcessing;

  const factory MeasureState.success({
    required TremorResult result,
    required String measurementId,
  }) = MeasureSuccess;

  const factory MeasureState.invalid(List<InvalidReason> reasons) =
      MeasureInvalid;

  const factory MeasureState.failure(Failure failure) = MeasureFailure;
}
