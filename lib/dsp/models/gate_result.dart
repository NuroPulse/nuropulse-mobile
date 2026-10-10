import 'package:nuropulse/dsp/models/gate_check.dart';

class GateResult {
  const GateResult({required this.check, required this.passed});

  final GateCheck check;
  final bool passed;
}
