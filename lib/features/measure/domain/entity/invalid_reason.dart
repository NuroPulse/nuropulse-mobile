import 'package:nuropulse/dsp/models/gate_check.dart';

/// Why a measurement is invalid; mirrors `GateCheck` plus [interrupted].
enum InvalidReason { sampling, dataGap, tooShort, flatSignal, interrupted }

/// Shared by the cubit (state) and the repository (upload payload), so the
/// mapping only lives in one place.
InvalidReason invalidReasonFor(GateCheck check) {
  return switch (check) {
    GateCheck.sampling => InvalidReason.sampling,
    GateCheck.dataGap => InvalidReason.dataGap,
    GateCheck.tooShort => InvalidReason.tooShort,
    GateCheck.flatSignal => InvalidReason.flatSignal,
  };
}
