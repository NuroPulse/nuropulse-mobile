import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/connection/domain/repositories/connection_repository.dart';
import 'package:nuropulse/features/connection/presentation/cubit/connection_state.dart';

class ConnectionCubit extends Cubit<DoctorConnectionState> {
  ConnectionCubit(this._repository) : super(const DoctorConnectionState.idle());

  final ConnectionRepository _repository;

  Future<bool> connect(String code) async {
    emit(const DoctorConnectionState.connecting());
    try {
      final doctor = await _repository.connect(code);
      emit(DoctorConnectionState.connected(doctor));
      return true;
    } on Failure catch (failure) {
      emit(DoctorConnectionState.failure(failure));
      return false;
    }
  }

  Future<void> loadConnectedDoctor(String doctorId) async {
    emit(const DoctorConnectionState.connecting());
    try {
      final doctor = await _repository.getConnectedDoctor(doctorId);
      emit(DoctorConnectionState.connected(doctor));
    } on Failure catch (failure) {
      emit(DoctorConnectionState.failure(failure));
    }
  }
}
