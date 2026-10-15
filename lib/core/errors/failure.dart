part 'sensor_failure.dart';
part 'analysis_failure.dart';
part 'storage_failure.dart';
part 'network_failure.dart';
part 'auth_failure.dart';

/// Failures thrown by repositories and caught by Cubits.
///
/// [message] is developer-facing English, logged only — never shown to the
/// user. The presentation layer maps each subtype to Indonesian text
/// (CLAUDE.md section 7).
///
/// Subtypes live in part files because a sealed class can only be extended
/// from its own library. Add more (ConnectionCodeFailure, ...) as their
/// features are built.
sealed class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}
