// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeasurementModel _$MeasurementModelFromJson(Map<String, dynamic> json) =>
    _MeasurementModel(
      id: json['id'] as String,
      patientId: json['patient_id'] as String?,
      measuredAt: json['measured_at'] as String,
      condition: json['condition'] as String,
      durationS: (json['duration_s'] as num).toInt(),
      status: json['status'] as String,
      invalidReason: json['invalid_reason'] as String?,
      features: json['features'] == null
          ? null
          : FeaturesModel.fromJson(json['features'] as Map<String, dynamic>),
      algoVersion: json['algo_version'] as String,
      device: DeviceModel.fromJson(json['device'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeasurementModelToJson(_MeasurementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patient_id': instance.patientId,
      'measured_at': instance.measuredAt,
      'condition': instance.condition,
      'duration_s': instance.durationS,
      'status': instance.status,
      'invalid_reason': instance.invalidReason,
      'features': _featuresToJson(instance.features),
      'algo_version': instance.algoVersion,
      'device': _deviceToJson(instance.device),
    };
