/// Typed view of assets/config/dsp_config.json.
///
/// Takes an already-decoded map. Loading the asset is the caller's job, so
/// lib/dsp/ stays free of I/O (CLAUDE.md section 3).
class DspConfig {
  const DspConfig({
    required this.algoVersion,
    required this.calibrated,
    required this.minEffectiveFsHz,
    required this.maxGapMs,
    required this.gridFsHz,
    required this.targetFsHz,
    required this.antiAliasSos,
    required this.bandpassSos,
    required this.dropEdgeS,
    required this.segmentS,
    required this.overlapFraction,
    required this.nfft,
    required this.peakSearchHz,
    required this.tremorBandHz,
    required this.ratioBandHz,
    required this.snrMin,
    required this.bandPowerRatioMin,
    required this.consistencyMin,
  });

  factory DspConfig.fromJson(Map<String, dynamic> json) {
    final gate = _section(json, 'qualityGate');
    final resample = _section(json, 'resample');
    final bandpass = _section(json, 'bandpass');
    final welch = _section(json, 'welch');
    final bands = _section(json, 'bands');
    final decision = _section(json, 'decision');

    return DspConfig(
      algoVersion: _string(json, 'algoVersion'),
      calibrated: _bool(json, 'calibrated'),
      minEffectiveFsHz: _double(gate, 'minEffectiveFsHz'),
      maxGapMs: _double(gate, 'maxGapMs'),
      gridFsHz: _double(resample, 'gridFsHz'),
      targetFsHz: _double(resample, 'targetFsHz'),
      antiAliasSos: _sos(resample, 'antiAliasSos'),
      bandpassSos: _sos(bandpass, 'sos'),
      dropEdgeS: _double(json, 'dropEdgeS'),
      segmentS: _double(welch, 'segmentS'),
      overlapFraction: _double(welch, 'overlapFraction'),
      nfft: _int(welch, 'nfft'),
      peakSearchHz: _range(bands, 'peakSearchHz'),
      tremorBandHz: _range(bands, 'tremorBandHz'),
      ratioBandHz: _range(bands, 'ratioBandHz'),
      snrMin: _double(decision, 'snrMin'),
      bandPowerRatioMin: _double(decision, 'bandPowerRatioMin'),
      consistencyMin: _double(decision, 'consistencyMin'),
    );
  }

  final String algoVersion;

  /// False until thresholds are calibrated. The UI shows a banner while false.
  final bool calibrated;

  final double minEffectiveFsHz;
  final double maxGapMs;
  final double gridFsHz;
  final double targetFsHz;

  /// Each row is one second-order section: b0, b1, b2, a0, a1, a2.
  final List<List<double>> antiAliasSos;
  final List<List<double>> bandpassSos;

  final double dropEdgeS;
  final double segmentS;
  final double overlapFraction;
  final int nfft;

  /// Each record is (low Hz, high Hz).
  final (double, double) peakSearchHz;
  final (double, double) tremorBandHz;
  final (double, double) ratioBandHz;

  final double snrMin;
  final double bandPowerRatioMin;
  final double consistencyMin;

  /// Welch segment length in samples at the target rate (4 s at 50 Hz = 200).
  int get segmentSamples => (segmentS * targetFsHz).round();

  /// Overlap between consecutive Welch segments (50% gives 100 at 200 samples).
  int get overlapSamples => (segmentSamples * overlapFraction).round();
}

const _sosRowLength = 6;

Map<String, dynamic> _section(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! Map<String, dynamic>) {
    throw FormatException('Missing config section: $key');
  }
  return value;
}

String _string(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String) throw FormatException('Expected string at $key');
  return value;
}

bool _bool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! bool) throw FormatException('Expected bool at $key');
  return value;
}

double _double(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! num) throw FormatException('Expected number at $key');
  return value.toDouble();
}

int _int(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int) throw FormatException('Expected integer at $key');
  return value;
}

(double, double) _range(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List || value.length != 2 || value.any((v) => v is! num)) {
    throw FormatException('Expected [low, high] at $key');
  }
  final low = (value[0] as num).toDouble();
  final high = (value[1] as num).toDouble();
  if (low >= high) {
    throw FormatException('Band must satisfy low < high at $key');
  }
  return (low, high);
}

List<List<double>> _sos(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List || value.isEmpty) {
    throw FormatException('Expected SOS rows at $key');
  }
  return value
      .map((row) {
        if (row is! List ||
            row.length != _sosRowLength ||
            row.any((v) => v is! num)) {
          throw FormatException(
            'Each SOS row at $key needs $_sosRowLength numbers',
          );
        }
        return row.map((v) => (v as num).toDouble()).toList(growable: false);
      })
      .toList(growable: false);
}
