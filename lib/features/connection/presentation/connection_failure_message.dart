import 'package:nuropulse/core/errors/failure.dart';

/// Indonesian text for a [ConnectionCodeFailure].
String connectionFailureMessage(Failure failure) {
  if (failure is ConnectionCodeFailure &&
      failure.reason == ConnectionCodeFailureReason.invalidCode) {
    return 'Kode koneksi tidak ditemukan. Periksa kembali kode dari dokter Anda.';
  }
  return 'Terjadi kesalahan. Silakan coba lagi.';
}
