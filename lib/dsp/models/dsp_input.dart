import 'dart:typed_data';

/// Raw sensor samples for one session. Timestamps are microseconds from the
/// sensor event, never array index or wall-clock time (CLAUDE.md section 6).
class DspInput {
  const DspInput({
    required this.tUs,
    required this.x,
    required this.y,
    required this.z,
  });

  final Int64List tUs;
  final Float64List x;
  final Float64List y;
  final Float64List z;

  List<Float64List> get axes => [x, y, z];
}
