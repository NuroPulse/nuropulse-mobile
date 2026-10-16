import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nuropulse/features/auth/domain/entity/profile.dart';
import 'package:nuropulse/features/auth/domain/entity/user_role.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// Wire shape of a `profiles` row, limited to the columns mobile reads.
/// `connection_code` is doctor-only and never needed here.
@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String role,
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
    @JsonKey(name: 'doctor_id') String? doctorId,
    @JsonKey(name: 'connected_at') String? connectedAt,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _ProfileModel;

  const ProfileModel._();

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Profile toEntity() {
    return Profile(
      id: id,
      role: UserRole.values.byName(role),
      fullName: fullName,
      email: email,
      doctorId: doctorId,
      connectedAt: connectedAt == null ? null : DateTime.parse(connectedAt!),
      createdAt: DateTime.parse(createdAt),
    );
  }
}
