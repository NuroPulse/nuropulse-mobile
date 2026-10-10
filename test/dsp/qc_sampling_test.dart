import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuropulse/dsp/stages/qc_sampling.dart';

import 'support/test_support.dart';

void main() {
  group('QcSampling.measure', () {
    test('reports about 100 Hz for a steady 10 ms period', () {
      final t = Int64List.fromList([
        for (var i = 0; i < 1001; i++) 1000000 + i * 10000,
      ]);

      final qc = QcSampling.measure(t);

      expect(qc.monotonic, isTrue);
      expect(qc.effectiveFsHz, closeTo(100.0, 1e-9));
      expect(qc.jitter, closeTo(0.0, 1e-12));
      expect(qc.maxGapMs, closeTo(10.0, 1e-9));
    });

    test('reports the largest interval as the gap', () {
      final t = jitteredTimestamps(seconds: 5);
      final shifted = Int64List.fromList([
        for (var i = 0; i < t.length; i++) i < 200 ? t[i] : t[i] + 300000,
      ]);

      final qc = QcSampling.measure(shifted);

      expect(qc.maxGapMs, closeTo(300, 15));
    });

    test('marks repeated timestamps as non-monotonic', () {
      final t = Int64List.fromList([1000000, 1010000, 1010000, 1020000]);

      final qc = QcSampling.measure(t);

      expect(qc.monotonic, isFalse);
      expect(qc.effectiveFsHz, 0);
    });

    test('marks decreasing timestamps as non-monotonic', () {
      final t = Int64List.fromList([1000000, 1020000, 1010000]);

      expect(QcSampling.measure(t).monotonic, isFalse);
    });

    test('treats fewer than two samples as non-monotonic', () {
      expect(
        QcSampling.measure(Int64List.fromList([1000000])).monotonic,
        isFalse,
      );
    });
  });
}
