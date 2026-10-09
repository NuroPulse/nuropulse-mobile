import 'dsp_debug_data.dart';
import 'gate_result.dart';
import 'qc_result.dart';
import 'tremor_features.dart';
import 'tremor_status.dart';

class TremorResult {
  const TremorResult({
    required this.status,
    required this.qc,
    required this.gates,
    this.features,
    this.debug,
  });

  final TremorStatus status;
  final QcResult qc;
  final List<GateResult> gates;

  /// Null when a gate failed before features were computed.
  final TremorFeatures? features;

  /// Null when a gate failed before the signal chain ran.
  final DspDebugData? debug;
}
