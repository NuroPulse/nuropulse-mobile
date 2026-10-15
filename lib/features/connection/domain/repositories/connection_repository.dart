import 'package:nuropulse/features/connection/domain/entity/connected_doctor.dart';

/// Connect a patient to a doctor by code, and read who they're connected
/// to. Throws [ConnectionCodeFailure] on failure.
abstract class ConnectionRepository {
  /// Validates [code] against a doctor's connection code, links the
  /// signed-in patient to them, and returns that doctor's info.
  Future<ConnectedDoctor> connect(String code);

  /// Info about the doctor at [doctorId], typically `Profile.doctorId` from
  /// `AuthRepository`.
  Future<ConnectedDoctor> getConnectedDoctor(String doctorId);
}
