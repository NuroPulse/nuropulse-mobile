part of 'failure.dart';

enum AuthFailureReason { wrongRole, other }

/// Registration, login, or logout failed: wrong credentials, a network
/// error, or a non-`patient` account signing in on mobile. [reason] lets
/// presentation pick a specific message for the role case without matching
/// on [message], which is English and internal only.
final class AuthFailure extends Failure {
  const AuthFailure(super.message, {this.reason = AuthFailureReason.other});

  final AuthFailureReason reason;
}
