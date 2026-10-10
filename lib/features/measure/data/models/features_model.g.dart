// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'features_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeaturesModel _$FeaturesModelFromJson(Map<String, dynamic> json) =>
    _FeaturesModel(
      peakFrequencyHz: (json['peak_frequency_hz'] as num).toDouble(),
      bandPowerRatio: (json['band_power_ratio'] as num).toDouble(),
      snr: (json['snr'] as num).toDouble(),
      bandRmsG: (json['band_rms_g'] as num).toDouble(),
      consistency: (json['consistency'] as num).toDouble(),
    );

Map<String, dynamic> _$FeaturesModelToJson(_FeaturesModel instance) =>
    <String, dynamic>{
      'peak_frequency_hz': instance.peakFrequencyHz,
      'band_power_ratio': instance.bandPowerRatio,
      'snr': instance.snr,
      'band_rms_g': instance.bandRmsG,
      'consistency': instance.consistency,
    };
