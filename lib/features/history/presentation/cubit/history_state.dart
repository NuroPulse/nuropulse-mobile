import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/measure/domain/entity/measurement_record.dart';

part 'history_state.freezed.dart';

/// loading | loaded | failure.
@freezed
sealed class HistoryState with _$HistoryState {
  const factory HistoryState.loading() = HistoryLoading;

  const factory HistoryState.loaded(List<MeasurementRecord> records) =
      HistoryLoaded;

  const factory HistoryState.failure(Failure failure) = HistoryFailure;
}
