import 'dart:math' as math;
import 'dart:typed_data';

import '../models/qc_result.dart';

class QcSampling {
  const QcSampling._();

  /// Measures the rate, jitter, and largest gap from the real timestamps.
  /// Repeated or decreasing timestamps are reported through [QcResult.monotonic]
  /// and never produce a rate.
  static QcResult measure(Int64List tUs) {
    if (tUs.length < 2) {
      return const QcResult(
        effectiveFsHz: 0,
        jitter: 0,
        maxGapMs: 0,
        monotonic: false,
      );
    }

    final n = tUs.length - 1;
    final intervals = Float64List(n);
    var monotonic = true;
    var sum = 0.0;
    var maxInterval = 0.0;
    for (var i = 0; i < n; i++) {
      final delta = tUs[i + 1] - tUs[i];
      if (delta <= 0) monotonic = false;
      final seconds = delta / 1e6;
      intervals[i] = seconds;
      sum += seconds;
      maxInterval = math.max(maxInterval, seconds);
    }

    if (!monotonic) {
      return const QcResult(
        effectiveFsHz: 0,
        jitter: 0,
        maxGapMs: 0,
        monotonic: false,
      );
    }

    final mean = sum / n;
    var variance = 0.0;
    for (final seconds in intervals) {
      variance += (seconds - mean) * (seconds - mean);
    }
    final std = math.sqrt(variance / n);
    final spanSeconds = (tUs[n] - tUs[0]) / 1e6;

    return QcResult(
      effectiveFsHz: n / spanSeconds,
      jitter: std / mean,
      maxGapMs: maxInterval * 1000,
      monotonic: true,
    );
  }
}
