import 'dart:typed_data';

/// Zero-phase second-order-section filter. Mirrors scipy.signal.sosfiltfilt:
/// odd-extension padding and steady-state initial conditions, applied forward
/// and then backward. Filter design happens in Python, never here.
class SosFilter {
  const SosFilter._();

  static Float64List filtfilt(Float64List x, List<List<double>> sos) {
    final padLength = _padLength(sos);
    if (x.length <= padLength) {
      throw ArgumentError('Signal of ${x.length} samples is too short to pad');
    }

    final padded = _oddExtension(x, padLength);
    final initial = _steadyStateInitial(sos);
    final forward = _runSections(padded, sos, initial, padded[0]);
    final backward = _runSections(
      _reversed(forward),
      sos,
      initial,
      forward[forward.length - 1],
    );
    final restored = _reversed(backward);
    return Float64List.sublistView(restored, padLength, padLength + x.length);
  }

  /// Same padding rule as SciPy: 3 * (2 * sections + 1), minus zero-coefficient
  /// terms. The shipped filters have none, so the result is 15 for two sections.
  static int _padLength(List<List<double>> sos) {
    var zeroB2 = 0;
    var zeroA2 = 0;
    for (final section in sos) {
      if (section[2] == 0) zeroB2++;
      if (section[5] == 0) zeroA2++;
    }
    final taps = 2 * sos.length + 1 - (zeroB2 < zeroA2 ? zeroB2 : zeroA2);
    return 3 * taps;
  }

  static Float64List _oddExtension(Float64List x, int pad) {
    final n = x.length;
    final out = Float64List(n + 2 * pad);
    final first = x[0];
    final last = x[n - 1];
    for (var k = 0; k < pad; k++) {
      out[k] = 2 * first - x[pad - k];
      out[pad + n + k] = 2 * last - x[n - 2 - k];
    }
    out.setRange(pad, pad + n, x);
    return out;
  }

  /// Steady-state state of each section for a unit step input. Each section's
  /// output becomes the next section's input level.
  static List<List<double>> _steadyStateInitial(List<List<double>> sos) {
    final states = <List<double>>[];
    var level = 1.0;
    for (final section in sos) {
      final c = _normalized(section);
      final b0 = c[0];
      final b1 = c[1];
      final b2 = c[2];
      final a1 = c[4];
      final a2 = c[5];
      final output = level * (b0 + b1 + b2) / (1 + a1 + a2);
      states.add([output - b0 * level, b2 * level - a2 * output]);
      level = output;
    }
    return states;
  }

  static Float64List _runSections(
    Float64List input,
    List<List<double>> sos,
    List<List<double>> initial,
    double startValue,
  ) {
    var signal = input;
    for (var s = 0; s < sos.length; s++) {
      final c = _normalized(sos[s]);
      final b0 = c[0];
      final b1 = c[1];
      final b2 = c[2];
      final a1 = c[4];
      final a2 = c[5];
      final out = Float64List(signal.length);
      var z1 = initial[s][0] * startValue;
      var z2 = initial[s][1] * startValue;
      for (var i = 0; i < signal.length; i++) {
        final xi = signal[i];
        final yi = b0 * xi + z1;
        z1 = b1 * xi - a1 * yi + z2;
        z2 = b2 * xi - a2 * yi;
        out[i] = yi;
      }
      signal = out;
    }
    return signal;
  }

  /// Returns [b0, b1, b2, 1, a1, a2] with a0 divided out.
  static List<double> _normalized(List<double> section) {
    final a0 = section[3];
    return [
      section[0] / a0,
      section[1] / a0,
      section[2] / a0,
      1.0,
      section[4] / a0,
      section[5] / a0,
    ];
  }

  static Float64List _reversed(Float64List x) {
    final out = Float64List(x.length);
    for (var i = 0; i < x.length; i++) {
      out[i] = x[x.length - 1 - i];
    }
    return out;
  }
}
