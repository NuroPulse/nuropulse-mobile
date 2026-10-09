import 'dart:typed_data';

import 'dsp_config.dart';
import 'models/dsp_debug_data.dart';
import 'models/dsp_input.dart';
import 'models/gate_result.dart';
import 'models/spectrum.dart';
import 'models/tremor_result.dart';
import 'models/tremor_status.dart';
import 'stages/decision_rule.dart';
import 'stages/feature_extractor.dart';
import 'stages/qc_sampling.dart';
import 'stages/quality_gate.dart';
import 'stages/resampler.dart';
import 'stages/sos_filter.dart';
import 'stages/welch.dart';

class TremorPipeline {
  const TremorPipeline(this.config);

  final DspConfig config;

  TremorResult analyze(DspInput input) {
    final qc = QcSampling.measure(input.tUs);
    final gates = <GateResult>[...QualityGate.checkSampling(qc, config)];
    if (gates.any((gate) => !gate.passed)) {
      return TremorResult(status: TremorStatus.invalid, qc: qc, gates: gates);
    }

    final resampled = [
      for (final axis in input.axes)
        Resampler.toTargetRate(input.tUs, axis, config),
    ];
    gates.add(QualityGate.checkFlatSignal(resampled));
    if (gates.any((gate) => !gate.passed)) {
      return TremorResult(status: TremorStatus.invalid, qc: qc, gates: gates);
    }

    // The edge drop trims the filter transient and the post-countdown tap.
    final drop = (config.dropEdgeS * config.targetFsHz).round();
    final demeaned = [for (final axis in resampled) _demean(axis)];
    final filtered = [
      for (final axis in demeaned)
        SosFilter.filtfilt(axis, config.bandpassSos).sublist(drop),
    ];
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
    final summed = spectra.reduce((a, b) => a.plus(b));
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
