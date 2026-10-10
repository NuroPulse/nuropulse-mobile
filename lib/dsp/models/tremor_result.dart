import 'package:nuropulse/dsp/models/dsp_debug_data.dart';
import 'package:nuropulse/dsp/models/gate_result.dart';
import 'package:nuropulse/dsp/models/qc_result.dart';
import 'package:nuropulse/dsp/models/tremor_features.dart';
import 'package:nuropulse/dsp/models/tremor_status.dart';

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
