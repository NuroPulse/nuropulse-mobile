import 'package:nuropulse/dsp/models/tremor_status.dart';

/// One saved measurement, for history and "last check" display — lighter
/// than [TremorResult], which carries the full DSP breakdown (gates, debug
/// spectrum, qc) that a list/summary view never needs. [TremorStatus] is a
/// `lib/dsp/` model, reused directly per CLAUDE.md section 6 rather than
/// duplicated here.
class MeasurementRecord {
  const MeasurementRecord({
    required this.id,
    required this.measuredAt,
    required this.status,
    required this.durationS,
    required this.uploaded,
    this.peakFrequencyHz,
  });

  final String id;
  final DateTime measuredAt;
  final TremorStatus status;
  final int durationS;
  final bool uploaded;

  /// Null when [status] is invalid — the contract never sends features then.
  final double? peakFrequencyHz;
}
