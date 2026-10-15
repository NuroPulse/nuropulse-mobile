part of 'failure.dart';

enum ConnectionCodeFailureReason { invalidCode, other }

/// Connecting to a doctor failed: a bad code, or a network/server error.
/// [reason] lets presentation pick a specific message without matching on
/// [message], which is English and internal only.
final class ConnectionCodeFailure extends Failure {
  const ConnectionCodeFailure(
    super.message, {
    this.reason = ConnectionCodeFailureReason.other,
  });

  final ConnectionCodeFailureReason reason;
}
