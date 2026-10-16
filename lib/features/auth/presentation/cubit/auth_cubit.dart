import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/auth/domain/entity/profile.dart';
import 'package:nuropulse/features/auth/domain/repositories/auth_repository.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:nuropulse/features/measure/domain/repositories/measurement_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository, this._measurements)
    : super(const AuthState.unauthenticated()) {
    _subscription = _repository.profileChanges.listen(
      _onProfileChanged,
      onError: _onProfileError,
    );
  }

  final AuthRepository _repository;
  final MeasurementRepository _measurements;
  late final StreamSubscription<Profile?> _subscription;

  /// Attaches measurements made while signed out to the account that just
  /// signed in (CLAUDE.md section 9 step 4). Fire-and-forget: neither
  /// method throws, and a failure here must never block login/registration.
  void _syncMeasurements() {
    unawaited(_measurements.claimAnonymousMeasurements());
    unawaited(_measurements.retryPendingUploads());
  }

  void _onProfileChanged(Profile? profile) {
    emit(
      profile == null
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(profile),
    );
  }

  /// A thrown [Failure] inside the stream (e.g. the profile fetch failing)
  /// would otherwise be an unhandled stream error and crash the app.
  void _onProfileError(Object error) {
    emit(
      AuthState.failure(
        error is Failure ? error : AuthFailure('Unexpected error: $error'),
      ),
    );
  }

  /// True if registration produced an active session, so the caller can
  /// navigate straight in. False means email confirmation is required, or
  /// registration failed (state already carries which).
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    emit(const AuthState.authenticating());
    try {
      final profile = await _repository.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      if (profile == null) {
        emit(const AuthState.unauthenticated());
        return false;
      }
      emit(AuthState.authenticated(profile));
      _syncMeasurements();
      return true;
    } on Failure catch (failure) {
      emit(AuthState.failure(failure));
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    emit(const AuthState.authenticating());
    try {
      final profile = await _repository.login(email: email, password: password);
      emit(AuthState.authenticated(profile));
      _syncMeasurements();
      return true;
    } on Failure catch (failure) {
      emit(AuthState.failure(failure));
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } on Failure {
      // profileChanges still reflects the real session; nothing more to do.
    }
  }

  /// Re-fetches the current profile, used after connecting to a doctor
  /// changes `profiles.doctor_id` out from under the cached [Profile].
  Future<void> refreshProfile() async {
    try {
      final profile = await _repository.refreshProfile();
      emit(AuthState.authenticated(profile));
    } on Failure catch (failure) {
      emit(AuthState.failure(failure));
    }
  }

  @override
  Future<void> close() {
    unawaited(_subscription.cancel());
    return super.close();
  }
}
