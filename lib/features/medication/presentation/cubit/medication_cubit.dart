import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_log_status.dart';
import 'package:nuropulse/features/medication/domain/repositories/medication_repository.dart';
import 'package:nuropulse/features/medication/presentation/cubit/medication_state.dart';

/// Doesn't load on construction: this is created once at the shell level,
/// before we know whether the user is signed in, so [MedicationPage]
/// triggers [load] itself once it confirms that.
class MedicationCubit extends Cubit<MedicationState> {
  MedicationCubit(this._repository) : super(const MedicationState.loading());

  final MedicationRepository _repository;

  Future<void> load() async {
    emit(const MedicationState.loading());
    try {
      final schedules = await _repository.getSchedules();
      final logs = await _repository.getLogs();
      emit(MedicationState.loaded(schedules: schedules, logs: logs));
    } on Failure catch (failure) {
      emit(MedicationState.failure(failure));
    }
  }

  Future<bool> logDose({
    required String scheduleId,
    required DateTime scheduledAt,
    required MedicationLogStatus status,
  }) async {
    try {
      await _repository.logDose(
        scheduleId: scheduleId,
        scheduledAt: scheduledAt,
        status: status,
      );
      await load();
      return true;
    } on Failure catch (failure) {
      emit(MedicationState.failure(failure));
      return false;
    }
  }
}
