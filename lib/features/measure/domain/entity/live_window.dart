import 'dart:typed_data';

/// The most recent samples for the live waveform. Display only, never used
/// for analysis.
class LiveWindow {
  const LiveWindow({required this.x, required this.y, required this.z});

  static final empty = LiveWindow(
    x: Float64List(0),
    y: Float64List(0),
    z: Float64List(0),
  );

  final Float64List x;
  final Float64List y;
  final Float64List z;
}
