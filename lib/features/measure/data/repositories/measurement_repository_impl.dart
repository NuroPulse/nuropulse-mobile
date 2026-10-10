import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/dsp/dsp_config.dart';
import 'package:nuropulse/dsp/models/dsp_input.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';
import 'package:nuropulse/dsp/tremor_pipeline.dart';
import 'package:nuropulse/features/measure/data/datasources/measurement_local_datasource.dart';
import 'package:nuropulse/features/measure/data/datasources/sensor_datasource.dart';
import 'package:nuropulse/features/measure/data/models/device_model.dart';
import 'package:nuropulse/features/measure/data/models/measurement_model.dart';
import 'package:nuropulse/features/measure/domain/entity/live_window.dart';
import 'package:nuropulse/features/measure/domain/entity/measure_outcome.dart';
import 'package:nuropulse/features/measure/domain/repositories/measurement_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MeasurementRepositoryImpl implements MeasurementRepository {
  MeasurementRepositoryImpl(
    this._sensors,
    this._local,
    this._dspConfig, [
    Uuid? uuid,
  ]) : _uuid = uuid ?? const Uuid();

  final SensorDatasource _sensors;
  final MeasurementLocalDatasource _local;
  final DspConfig _dspConfig;
  final Uuid _uuid;

  final _samples = <RawSample>[];
  StreamSubscription<RawSample>? _subscription;
  Object? _sensorError;
  Duration? _duration;

  @override
  Future<void> startRecording(Duration duration) async {
    _samples.clear();
    _sensorError = null;
    _duration = duration;
    try {
      _subscription = _sensors.userAccelerometer().listen(
        _samples.add,
        onError: (Object error) => _sensorError ??= error,
      );
      await WakelockPlus.enable();
    } catch (error, stackTrace) {
      await cancelRecording();
      Error.throwWithStackTrace(
        SensorFailure('Failed to start sensor: $error'),
        stackTrace,
      );
    }
  }

  @override
  LiveWindow liveWindow(int samples) {
    final start = _samples.length > samples ? _samples.length - samples : 0;
    final window = _samples.sublist(start);
    return LiveWindow(
      x: Float64List.fromList([for (final s in window) s.x]),
      y: Float64List.fromList([for (final s in window) s.y]),
      z: Float64List.fromList([for (final s in window) s.z]),
    );
  }

  @override
  Future<void> cancelRecording() async {
    await _stopListening();
    _samples.clear();
  }

  @override
  Future<MeasureOutcome> finishRecording() async {
    // Read the error before stopping, because stopping clears it.
    final error = _sensorError;
    await _stopListening();
    if (error != null) {
      _samples.clear();
      throw SensorFailure('Sensor stream failed: $error');
    }

    final input = _buildInput();
    _samples.clear();

    final result = await _analyze(input);
    final id = _uuid.v4();
    final model = await _buildModel(id, result);

    try {
      // Not uploaded yet: no backend/auth is wired up (CLAUDE.md section 13
      // items 2 and 5 are still open, and supabase_flutter isn't a
      // dependency yet). Stays local with uploaded = false until that lands.
      await _local.save(id, model.toJson(), uploaded: false);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageFailure('Failed to save measurement: $error'),
        stackTrace,
      );
    }

    return MeasureOutcome(measurementId: id, result: result);
  }

  DspInput _buildInput() {
    return DspInput(
      tUs: Int64List.fromList([for (final s in _samples) s.tUs]),
      x: Float64List.fromList([for (final s in _samples) s.x]),
      y: Float64List.fromList([for (final s in _samples) s.y]),
      z: Float64List.fromList([for (final s in _samples) s.z]),
    );
  }

  Future<TremorResult> _analyze(DspInput input) async {
    final config = _dspConfig;
    try {
      return await Isolate.run(() => TremorPipeline(config).analyze(input));
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AnalysisFailure('DSP pipeline failed: $error'),
        stackTrace,
      );
    }
  }

  Future<MeasurementModel> _buildModel(String id, TremorResult result) async {
    return MeasurementModel.fromResult(
      id: id,
      measuredAt: DateTime.now(),
      durationS: _duration!.inSeconds,
      result: result,
      algoVersion: _dspConfig.algoVersion,
      device: await _deviceModel(result.qc.effectiveFsHz),
    );
  }

  Future<DeviceModel> _deviceModel(double effectiveSamplingHz) async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!Platform.isAndroid) {
      // Android first; iOS later (CLAUDE.md section 2).
      return DeviceModel(
        model: Platform.operatingSystem,
        os: 'ios',
        appVersion: packageInfo.version,
        effectiveSamplingHz: effectiveSamplingHz,
      );
    }
    final info = await DeviceInfoPlugin().androidInfo;
    return DeviceModel(
      model: info.model,
      os: 'android',
      appVersion: packageInfo.version,
      effectiveSamplingHz: effectiveSamplingHz,
    );
  }

  Future<void> _stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
    _sensorError = null;
    await WakelockPlus.disable();
  }
}
