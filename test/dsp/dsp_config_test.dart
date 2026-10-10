import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuropulse/dsp/dsp_config.dart';

Map<String, dynamic> _loadShippedJson() {
  final text = File('assets/config/dsp_config.json').readAsStringSync();
  return jsonDecode(text) as Map<String, dynamic>;
}

void main() {
  group('DspConfig.fromJson', () {
    test('loads the shipped config with uncalibrated thresholds', () {
      final config = DspConfig.fromJson(_loadShippedJson());

      expect(config.algoVersion, '0.2.0-dev');
      expect(config.calibrated, isFalse);
      expect(config.targetFsHz, 50.0);
      expect(config.nfft, 256);
      expect(config.tremorBandHz, (3.5, 7.0));
      expect(config.peakSearchHz, (3.0, 12.0));
      expect(config.minDurationS, 8.0);
    });

    test('keeps SOS rows exactly as exported by export_sos.py', () {
      final config = DspConfig.fromJson(_loadShippedJson());

      expect(config.bandpassSos, hasLength(2));
      expect(config.bandpassSos.first[0], closeTo(0.5825177969900295, 1e-15));
      expect(config.antiAliasSos.last[5], closeTo(0.4663255707632367, 1e-15));
    });

    test('throws FormatException when a section is missing', () {
      final json = _loadShippedJson()..remove('welch');

      expect(() => DspConfig.fromJson(json), throwsFormatException);
    });

    test('throws FormatException when an SOS row has the wrong length', () {
      final json = _loadShippedJson();
      (json['bandpass'] as Map<String, dynamic>)['sos'] = [
        [1.0, 2.0, 3.0],
      ];

      expect(() => DspConfig.fromJson(json), throwsFormatException);
    });

    test('throws FormatException when a band is not low < high', () {
      final json = _loadShippedJson();
      (json['bands'] as Map<String, dynamic>)['tremorBandHz'] = [7.0, 3.5];

      expect(() => DspConfig.fromJson(json), throwsFormatException);
    });
  });
}
