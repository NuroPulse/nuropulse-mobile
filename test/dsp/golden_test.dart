import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuropulse/dsp/models/dsp_input.dart';
import 'package:nuropulse/dsp/tremor_pipeline.dart';

import 'support/test_support.dart';

/// Golden cases exported by tools/python/export_golden.py in biomarker_demo.
/// Each case carries its own input and expected values, so Dart and SciPy
/// are compared on the same numbers.
void main() {
  final config = loadShippedConfig();
  final files = Directory(
    'test/dsp/golden',
  ).listSync().whereType<File>().where((file) => file.path.endsWith('.json'));

  for (final file in files) {
    final golden = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final name = golden['name'] as String;

    test('matches the Python reference: $name', () {
      final input = golden['input'] as Map<String, dynamic>;
      final dspInput = DspInput(
        tUs: Int64List.fromList((input['t_us'] as List).cast<int>()),
        x: _doubles(input['x']),
        y: _doubles(input['y']),
        z: _doubles(input['z']),
      );
      final expected = golden['expected'] as Map<String, dynamic>;
      final tolerance = golden['tolerance'] as Map<String, dynamic>;

      final result = TremorPipeline(config).analyze(dspInput);
      final features = result.features!;
      final expectedFeatures = expected['features'] as Map<String, dynamic>;
      final relative = (tolerance['relative'] as num).toDouble();
      final frequencyAbs = (tolerance['peakFrequencyHz_abs'] as num).toDouble();

      expect(
        features.peakFrequencyHz,
        closeTo(_num(expectedFeatures, 'peakFrequencyHz'), frequencyAbs),
        reason: 'peakFrequencyHz',
      );
      _expectRelative(
        features.bandPowerRatio,
        expectedFeatures,
        'bandPowerRatio',
        relative,
      );
      _expectRelative(features.snr, expectedFeatures, 'snr', relative);
      _expectRelative(features.bandRms, expectedFeatures, 'bandRms', relative);
      _expectRelative(
        features.consistency,
        expectedFeatures,
        'consistency',
        relative,
      );
    });
  }
}

Float64List _doubles(Object? values) {
  return Float64List.fromList(
    (values as List).cast<num>().map((v) => v.toDouble()).toList(),
  );
}

double _num(Map<String, dynamic> map, String key) =>
    (map[key] as num).toDouble();

void _expectRelative(
  double actual,
  Map<String, dynamic> expected,
  String key,
  double relative,
) {
  final want = _num(expected, key);
  final allowed = relative * want.abs();
  expect(actual, closeTo(want, allowed), reason: key);
}
