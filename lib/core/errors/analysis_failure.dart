part of 'failure.dart';

/// The DSP pipeline (lib/dsp/) threw while analyzing a recording.
final class AnalysisFailure extends Failure {
  const AnalysisFailure(super.message);
}
