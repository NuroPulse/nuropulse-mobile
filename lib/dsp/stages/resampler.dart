import 'dart:typed_data';

import 'package:nuropulse/dsp/dsp_config.dart';
import 'package:nuropulse/dsp/stages/sos_filter.dart';

class Resampler {
  const Resampler._();

  /// Linear interpolation onto a uniform grid, anti-alias low-pass, then
  /// decimation to the target rate. Requires strictly increasing timestamps,
  /// which the QC stage checks first.
  static Float64List toTargetRate(
    Int64List tUs,
    Float64List x,
    DspConfig config,
  ) {
    final ratio = (config.gridFsHz / config.targetFsHz).round();
    if ((ratio * config.targetFsHz - config.gridFsHz).abs() > 1e-9) {
      throw ArgumentError('gridFsHz must be an integer multiple of targetFsHz');
    }

    final grid = _interpolate(tUs, x, config.gridFsHz);
    final filtered = SosFilter.filtfilt(grid, config.antiAliasSos);

    final out = Float64List((filtered.length + ratio - 1) ~/ ratio);
    for (var i = 0, j = 0; i < filtered.length; i += ratio, j++) {
      out[j] = filtered[i];
    }
    return out;
  }

  static Float64List _interpolate(Int64List tUs, Float64List x, double gridFs) {
    final t0 = tUs[0];
    final tEnd = (tUs[tUs.length - 1] - t0) / 1e6;
    final count = (tEnd * gridFs).ceil();
    final out = Float64List(count);

    var j = 0;
    for (var i = 0; i < count; i++) {
      final g = i / gridFs;
      while (j < tUs.length - 2 && (tUs[j + 1] - t0) / 1e6 < g) {
        j++;
      }
      final ta = (tUs[j] - t0) / 1e6;
      final tb = (tUs[j + 1] - t0) / 1e6;
      final w = (g - ta) / (tb - ta);
      out[i] = x[j] + w * (x[j + 1] - x[j]);
    }
    return out;
  }
}
