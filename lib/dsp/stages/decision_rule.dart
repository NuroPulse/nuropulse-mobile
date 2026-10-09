import '../dsp_config.dart';
import '../models/gate_result.dart';
import '../models/tremor_features.dart';
import '../models/tremor_status.dart';

class DecisionRule {
  const DecisionRule._();

  /// Rule-based and transparent. Any failed gate is invalid. Otherwise the
  /// peak must sit in the tremor band and every threshold must be met.
  static TremorStatus decide({
    required List<GateResult> gates,
    required TremorFeatures? features,
    required DspConfig config,
  }) {
    if (features == null || gates.any((gate) => !gate.passed)) {
      return TremorStatus.invalid;
    }

    final band = config.tremorBandHz;
    final peakInBand =
        features.peakFrequencyHz >= band.$1 &&
        features.peakFrequencyHz <= band.$2;
    final met =
        peakInBand &&
        features.snr >= config.snrMin &&
        features.bandPowerRatio >= config.bandPowerRatioMin &&
        features.consistency >= config.consistencyMin;

    return met ? TremorStatus.tremor : TremorStatus.none;
  }
}
