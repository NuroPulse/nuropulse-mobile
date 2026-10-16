import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/dsp/dsp_config.dart';
import 'package:nuropulse/dsp/models/dsp_input.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';
import 'package:nuropulse/dsp/models/tremor_status.dart';
import 'package:nuropulse/dsp/tremor_pipeline.dart';
import 'package:nuropulse/features/measure/data/datasources/measurement_local_datasource.dart';
import 'package:nuropulse/features/measure/data/datasources/measurement_remote_datasource.dart';
import 'package:nuropulse/features/measure/data/datasources/sensor_datasource.dart';
import 'package:nuropulse/features/measure/data/models/device_model.dart';
import 'package:nuropulse/features/measure/data/models/measurement_model.dart';
import 'package:nuropulse/features/measure/domain/entity/live_window.dart';
import 'package:nuropulse/features/measure/domain/entity/measure_outcome.dart';
import 'package:nuropulse/features/measure/domain/entity/measurement_record.dart';
import 'package:nuropulse/features/measure/domain/repositories/measurement_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MeasurementRepositoryImpl implements MeasurementRepository {
  MeasurementRepositoryImpl(
    this._sensors,
    this._local,
    this._remote,
    this._dspConfig, [
    Uuid? uuid,
  ]) : _uuid = uuid ?? const Uuid();

  final SensorDatasource _sensors;
  final MeasurementLocalDatasource _local;
  final MeasurementRemoteDatasource _remote;
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
      await _local.save(id, model.toJson(), uploaded: false);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageFailure('Failed to save measurement: $error'),
        stackTrace,
      );
    }

    // A failed upload is not a failure of the check itself: the result
    // stays local with uploaded = false and retries later (CLAUDE.md
    // section 9 step 4), covering both offline and the `anon` role still
    // missing an INSERT grant on `measurements`.
    try {
      await _remote.upload(model.toJson());
      await _local.save(id, model.toJson(), uploaded: true);
    } catch (_) {
      // Left pending; retryPendingUploads() picks it up later.
    }

    return MeasureOutcome(measurementId: id, result: result);
  }

  @override
  Future<void> retryPendingUploads() async {
    final userId = _remote.currentUserId;
    for (final entry in _local.readAll()) {
      if (entry['uploaded'] == true) continue;
      var model = MeasurementModel.fromJson(
        entry['measurement'] as Map<String, dynamic>,
      );
      // Never uploaded before, so there is no anonymous row to orphan:
      // attribute it to the account that is signed in now.
      if (userId != null && model.patientId == null) {
        model = model.copyWith(patientId: userId);
      }
      try {
        await _remote.upload(model.toJson());
        await _local.save(model.id, model.toJson(), uploaded: true);
      } catch (_) {
        // Stays pending for the next retry.
      }
    }
  }

  @override
  Future<void> claimAnonymousMeasurements() async {
    final userId = _remote.currentUserId;
    if (userId == null) return;

    final toClaim = <MeasurementModel>[];
    for (final entry in _local.readAll()) {
      if (entry['uploaded'] != true) continue;
      final model = MeasurementModel.fromJson(
        entry['measurement'] as Map<String, dynamic>,
      );
      if (model.patientId == null) toClaim.add(model);
    }
    if (toClaim.isEmpty) return;

    try {
      await _remote.claim([for (final model in toClaim) model.id]);
      for (final model in toClaim) {
        final claimed = model.copyWith(patientId: userId);
        await _local.save(claimed.id, claimed.toJson(), uploaded: true);
      }
    } catch (_) {
      // Retried on the next login; the RPC is a no-op for already-claimed
      // ids, so re-attempting is harmless.
    }
  }

  @override
  Future<List<MeasurementRecord>> getMeasurements() async {
    try {
      final records = [for (final entry in _local.readAll()) _toRecord(entry)]
        ..sort((a, b) => b.measuredAt.compareTo(a.measuredAt));
      return records;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageFailure('Failed to read measurements: $error'),
        stackTrace,
      );
    }
  }

  MeasurementRecord _toRecord(Map<String, dynamic> entry) {
    final model = MeasurementModel.fromJson(
      entry['measurement'] as Map<String, dynamic>,
    );
    return MeasurementRecord(
      id: model.id,
      measuredAt: DateTime.parse(model.measuredAt),
      status: TremorStatus.values.byName(model.status),
      durationS: model.durationS,
      uploaded: entry['uploaded'] as bool,
      peakFrequencyHz: model.features?.peakFrequencyHz,
    );
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
      patientId: _remote.currentUserId,
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
