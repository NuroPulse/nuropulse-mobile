// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => _DeviceModel(
  model: json['model'] as String,
  os: json['os'] as String,
  appVersion: json['app_version'] as String,
  effectiveSamplingHz: (json['effective_sampling_hz'] as num).toDouble(),
);

Map<String, dynamic> _$DeviceModelToJson(_DeviceModel instance) =>
    <String, dynamic>{
      'model': instance.model,
      'os': instance.os,
      'app_version': instance.appVersion,
      'effective_sampling_hz': instance.effectiveSamplingHz,
    };
