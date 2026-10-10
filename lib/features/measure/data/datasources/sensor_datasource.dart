import 'package:sensors_plus/sensors_plus.dart';

/// One reading with the sensor's own timestamp in microseconds (CLAUDE.md
/// section 9). Never use array index or DateTime.now().
class RawSample {
  const RawSample({
    required this.tUs,
    required this.x,
    required this.y,
    required this.z,
  });

  final int tUs;
  final double x;
  final double y;
  final double z;
}

/// Thin wrapper over sensors_plus. Only the gravity-removed user
/// accelerometer is read — raw accelerometer and gyroscope are not needed
/// and raw signals are never stored (CLAUDE.md section 9).
class SensorDatasource {
  static const samplingPeriod = Duration(milliseconds: 10);

  Stream<RawSample> userAccelerometer() {
    return userAccelerometerEventStream(samplingPeriod: samplingPeriod).map(
      (event) => RawSample(
        tUs: event.timestamp.microsecondsSinceEpoch,
        x: event.x,
        y: event.y,
        z: event.z,
      ),
    );
  }
}
