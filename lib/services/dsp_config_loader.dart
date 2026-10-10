import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/dsp/dsp_config.dart';

const _dspConfigAsset = 'assets/config/dsp_config.json';

/// Loads and validates the DSP config from the bundled asset. Only this
/// service touches the asset bundle, so lib/dsp/ stays free of I/O.
class DspConfigLoader {
  const DspConfigLoader._();

  static Future<DspConfig> load() async {
    final text = await rootBundle.loadString(_dspConfigAsset);
    try {
      final json = jsonDecode(text) as Map<String, dynamic>;
      return DspConfig.fromJson(json);
    } on FormatException catch (error) {
      throw AnalysisFailure('Invalid $_dspConfigAsset: ${error.message}');
    }
  }
}
