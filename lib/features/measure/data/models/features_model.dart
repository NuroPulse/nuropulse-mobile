import 'package:freezed_annotation/freezed_annotation.dart';

part 'features_model.freezed.dart';
part 'features_model.g.dart';

/// `features` object in the Measurement contract (CLAUDE.md section 4).
/// Not present when `status` is `invalid`.
@freezed
abstract class FeaturesModel with _$FeaturesModel {
  const factory FeaturesModel({
    @JsonKey(name: 'peak_frequency_hz') required double peakFrequencyHz,
    @JsonKey(name: 'band_power_ratio') required double bandPowerRatio,
    required double snr,

    /// Already in g — converted from lib/dsp's m/s² value when this model
    /// is built. See `MeasurementModel.fromResult`.
    @JsonKey(name: 'band_rms_g') required double bandRmsG,
    required double consistency,
  }) = _FeaturesModel;

  factory FeaturesModel.fromJson(Map<String, dynamic> json) =>
      _$FeaturesModelFromJson(json);
}
