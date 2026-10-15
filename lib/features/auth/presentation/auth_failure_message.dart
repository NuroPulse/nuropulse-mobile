import 'package:nuropulse/core/errors/failure.dart';

/// Indonesian text for an [AuthFailure], shared by the login and register
/// screens so the wording never drifts between them.
String authFailureMessage(Failure failure) {
  if (failure is AuthFailure && failure.reason == AuthFailureReason.wrongRole) {
    return 'Akun dokter tidak bisa masuk lewat aplikasi ini.';
  }
  return 'Email atau kata sandi salah, atau terjadi kesalahan. Silakan coba lagi.';
}
