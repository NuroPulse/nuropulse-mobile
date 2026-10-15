import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/auth/domain/entity/profile.dart';

part 'auth_state.freezed.dart';

/// unauthenticated | authenticating | authenticated | failure.
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  const factory AuthState.authenticating() = AuthAuthenticating;

  const factory AuthState.authenticated(Profile profile) = AuthAuthenticated;

  const factory AuthState.failure(Failure failure) = AuthFailureState;
}
