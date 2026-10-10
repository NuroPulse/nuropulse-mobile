import 'dart:typed_data';

import 'package:nuropulse/dsp/dsp_config.dart';
import 'package:nuropulse/dsp/models/dsp_debug_data.dart';
import 'package:nuropulse/dsp/models/dsp_input.dart';
import 'package:nuropulse/dsp/models/gate_check.dart';
import 'package:nuropulse/dsp/models/gate_result.dart';
import 'package:nuropulse/dsp/models/spectrum.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';
import 'package:nuropulse/dsp/models/tremor_status.dart';
import 'package:nuropulse/dsp/stages/decision_rule.dart';
import 'package:nuropulse/dsp/stages/feature_extractor.dart';
import 'package:nuropulse/dsp/stages/qc_sampling.dart';
import 'package:nuropulse/dsp/stages/quality_gate.dart';
import 'package:nuropulse/dsp/stages/resampler.dart';
import 'package:nuropulse/dsp/stages/sos_filter.dart';
import 'package:nuropulse/dsp/stages/welch.dart';

class TremorPipeline {
  const TremorPipeline(this.config);

  final DspConfig config;

  TremorResult analyze(DspInput input) {
    final qc = QcSampling.measure(input.tUs);
    final gates = <GateResult>[...QualityGate.checkSampling(qc, config)];
    if (gates.any((gate) => !gate.passed)) {
      return TremorResult(status: TremorStatus.invalid, qc: qc, gates: gates);
    }

    // The edge drop trims the filter transient and the post-countdown tap.
    final drop = (config.dropEdgeS * config.targetFsHz).round();
    final List<Float64List> resampled;
    final List<Float64List> demeaned;
    final List<Float64List> filtered;
    try {
      resampled = [
        for (final axis in input.axes)
          Resampler.toTargetRate(input.tUs, axis, config),
      ];
      demeaned = [for (final axis in resampled) _demean(axis)];
      filtered = [
        for (final axis in demeaned)
          SosFilter.filtfilt(axis, config.bandpassSos).sublist(drop),
      ];
    } on ArgumentError {
      // The configured minDurationS passed, but this combination of
      // dropEdgeS/segmentS/filter length still leaves too few samples to
      // filter.
      gates.add(const GateResult(check: GateCheck.tooShort, passed: false));
      return TremorResult(status: TremorStatus.invalid, qc: qc, gates: gates);
    }

    gates.add(QualityGate.checkFlatSignal(resampled));
    if (gates.any((gate) => !gate.passed)) {
      return TremorResult(status: TremorStatus.invalid, qc: qc, gates: gates);
    }

    final Spectrum summed;
    try {
      final spectra = [
        for (final axis in filtered)
          Welch.compute(
            axis,
            fs: config.targetFsHz,
            segmentLength: config.segmentSamples,
            overlap: config.overlapSamples,
            nfft: config.nfft,
          ),
      ];
      summed = spectra.reduce((a, b) => a.plus(b));
    } on ArgumentError {
      gates.add(const GateResult(check: GateCheck.tooShort, passed: false));
      return TremorResult(status: TremorStatus.invalid, qc: qc, gates: gates);
    }

    final features = FeatureExtractor.compute(summed, filtered, config);
    final status = DecisionRule.decide(
      gates: gates,
      features: features,
      config: config,
    );

    return TremorResult(
      status: status,
      qc: qc,
      gates: gates,
      features: features,
      debug: DspDebugData(
        rawX: demeaned[0].sublist(drop),
        filteredX: filtered[0],
        spectrum: Spectrum(
          frequencies: summed.frequencies,
          power: summed.power,
        ),
      ),
    );
  }

  Float64List _demean(Float64List resampled) {
    var mean = 0.0;
    for (final value in resampled) {
      mean += value;
    }
    mean /= resampled.length;

    final out = Float64List(resampled.length);
    for (var i = 0; i < resampled.length; i++) {
      out[i] = resampled[i] - mean;
    }
    return out;
  }
}
