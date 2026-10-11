import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/history/presentation/cubit/history_state.dart';
import 'package:nuropulse/features/measure/domain/repositories/measurement_repository.dart';

/// Loads saved measurements for the history list and the home dashboard's
/// "last check" card — both read from the same [MeasurementRepository], so
/// one cubit instance (provided above both tabs) serves either view.
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._repository) : super(const HistoryState.loading()) {
    load();
  }

  final MeasurementRepository _repository;

  Future<void> load() async {
    emit(const HistoryState.loading());
    try {
      final records = await _repository.getMeasurements();
      emit(HistoryState.loaded(records));
    } on Failure catch (failure) {
      emit(HistoryState.failure(failure));
    }
  }
}
