part of 'failure.dart';

/// Registration, login, or logout failed: wrong credentials, a network
/// error, or a non-`patient` account signing in on mobile.
final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
