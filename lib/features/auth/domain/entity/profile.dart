import 'package:nuropulse/features/auth/domain/entity/user_role.dart';

/// The signed-in user's `profiles` row. [role] is always [UserRole.patient]
/// here, since [AuthRepository] signs out anything else first.
class Profile {
  const Profile({
    required this.id,
    required this.role,
    required this.fullName,
    required this.email,
    required this.createdAt,
    this.doctorId,
    this.connectedAt,
  });

  final String id;
  final UserRole role;
  final String fullName;
  final String email;
  final DateTime createdAt;

  /// Set once this patient connects to a doctor.
  final String? doctorId;
  final DateTime? connectedAt;
}
