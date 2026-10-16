import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_log_entry.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_schedule.dart';

part 'medication_state.freezed.dart';

/// loading | loaded | failure.
@freezed
sealed class MedicationState with _$MedicationState {
  const factory MedicationState.loading() = MedicationLoading;

  const factory MedicationState.loaded({
    required List<MedicationSchedule> schedules,
    required List<MedicationLogEntry> logs,
  }) = MedicationLoaded;

  const factory MedicationState.failure(Failure failure) =
      MedicationFailureState;
}
