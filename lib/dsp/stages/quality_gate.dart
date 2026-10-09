import 'dart:typed_data';

import '../dsp_config.dart';
import '../models/gate_check.dart';
import '../models/gate_result.dart';
import '../models/qc_result.dart';

class QualityGate {
  const QualityGate._();

  /// Runs before any signal processing. A failure makes the result invalid.
  static List<GateResult> checkSampling(QcResult qc, DspConfig config) {
    return [
      GateResult(
        check: GateCheck.sampling,
        passed: qc.monotonic && qc.effectiveFsHz >= config.minEffectiveFsHz,
      ),
      GateResult(
        check: GateCheck.dataGap,
        passed: qc.monotonic && qc.maxGapMs <= config.maxGapMs,
      ),
    ];
  }

  /// A constant signal on every axis is a dead sensor or a missing recording.
  /// It must be reported as invalid, never as "no tremor" (CLAUDE.md section 10).
  static GateResult checkFlatSignal(List<Float64List> resampledAxes) {
    final allFlat = resampledAxes.every(_isConstant);
    return GateResult(check: GateCheck.flatSignal, passed: !allFlat);
  }

  static bool _isConstant(Float64List x) {
    for (final value in x) {
      if (value != x[0]) return false;
    }
    return true;
  }
}
