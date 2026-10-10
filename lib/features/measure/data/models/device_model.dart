import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_model.freezed.dart';
part 'device_model.g.dart';

/// `device` object in the Measurement contract (CLAUDE.md section 13 item 4).
@freezed
abstract class DeviceModel with _$DeviceModel {
  const factory DeviceModel({
    required String model,
    required String os,
    @JsonKey(name: 'app_version') required String appVersion,
    @JsonKey(name: 'effective_sampling_hz') required double effectiveSamplingHz,
  }) = _DeviceModel;

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);
}
