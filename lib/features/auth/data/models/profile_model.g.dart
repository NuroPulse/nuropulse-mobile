// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    _ProfileModel(
      id: json['id'] as String,
      role: json['role'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      doctorId: json['doctor_id'] as String?,
      connectedAt: json['connected_at'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$ProfileModelToJson(_ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'full_name': instance.fullName,
      'email': instance.email,
      'doctor_id': instance.doctorId,
      'connected_at': instance.connectedAt,
      'created_at': instance.createdAt,
    };
