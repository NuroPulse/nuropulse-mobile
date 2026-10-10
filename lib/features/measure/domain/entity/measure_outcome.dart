import 'package:nuropulse/dsp/models/tremor_result.dart';

/// A finished recording: its saved id and its analysis.
class MeasureOutcome {
  const MeasureOutcome({required this.measurementId, required this.result});

  final String measurementId;
  final TremorResult result;
}
