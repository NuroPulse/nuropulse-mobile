import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';
import 'package:nuropulse/features/measure/data/models/device_model.dart';
import 'package:nuropulse/features/measure/data/models/features_model.dart';
import 'package:nuropulse/features/measure/domain/entity/invalid_reason.dart';

part 'measurement_model.freezed.dart';
part 'measurement_model.g.dart';

/// Standard gravity, m/s² — converts lib/dsp's `bandRms` (m/s²) to the
/// contract's `band_rms_g` (CLAUDE.md section 4).
const gravityMs2 = 9.80665;

/// Wire shape of the Measurement contract (CLAUDE.md section 4). Built from
/// a [TremorResult] by [fromResult]; `lib/dsp/` itself never sees this type.
@Freezed(toJson: true, fromJson: true)
abstract class MeasurementModel with _$MeasurementModel {
  const factory MeasurementModel({
    required String id,
    @JsonKey(name: 'patient_id') String? patientId,

    /// UTC ISO-8601, device time.
    @JsonKey(name: 'measured_at') required String measuredAt,

    /// Always "rest" in this version.
    required String condition,
    @JsonKey(name: 'duration_s') required int durationS,

    /// "none" | "tremor" | "invalid".
    required String status,
    @JsonKey(name: 'invalid_reason') String? invalidReason,
    @JsonKey(toJson: _featuresToJson) FeaturesModel? features,
    @JsonKey(name: 'algo_version') required String algoVersion,
    @JsonKey(toJson: _deviceToJson) required DeviceModel device,
  }) = _MeasurementModel;

  const MeasurementModel._();

  factory MeasurementModel.fromJson(Map<String, dynamic> json) =>
      _$MeasurementModelFromJson(json);

  /// Builds the payload for one finished, analyzed recording.
  factory MeasurementModel.fromResult({
    required String id,
    required DateTime measuredAt,
    required int durationS,
    required TremorResult result,
    required String algoVersion,
    required DeviceModel device,
    String? patientId,
  }) {
    final failedGate = result.gates.where((gate) => !gate.passed).firstOrNull;
    final features = result.features;

    return MeasurementModel(
      id: id,
      patientId: patientId,
      measuredAt: measuredAt.toUtc().toIso8601String(),
      condition: 'rest',
      durationS: durationS,
      status: result.status.name,
      invalidReason: failedGate == null
          ? null
          : _wireReason(invalidReasonFor(failedGate.check)),
      features: features == null
          ? null
          : FeaturesModel(
              peakFrequencyHz: features.peakFrequencyHz,
              bandPowerRatio: features.bandPowerRatio,
              snr: features.snr,
              bandRmsG: features.bandRms / gravityMs2,
              consistency: features.consistency,
            ),
      algoVersion: algoVersion,
      device: device,
    );
  }
}

/// Maps to the contract's `invalid_reason` strings (CLAUDE.md section 13
/// item 3). `flat_signal` and `interrupted` are additions beyond that list —
/// recorded there, not invented here.
String _wireReason(InvalidReason reason) {
  return switch (reason) {
    InvalidReason.sampling => 'low_sampling_rate',
    InvalidReason.dataGap => 'sampling_gap',
    InvalidReason.tooShort => 'too_short',
    InvalidReason.flatSignal => 'flat_signal',
    InvalidReason.interrupted => 'interrupted',
  };
}

// Nested models must become Maps for Hive and jsonEncode.
Map<String, dynamic>? _featuresToJson(FeaturesModel? value) => value?.toJson();

Map<String, dynamic> _deviceToJson(DeviceModel value) => value.toJson();
