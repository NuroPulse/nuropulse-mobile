import 'package:flutter/material.dart';
import 'package:nuropulse/app.dart';
import 'package:nuropulse/features/measure/data/datasources/measurement_local_datasource.dart';
import 'package:nuropulse/features/measure/data/datasources/sensor_datasource.dart';
import 'package:nuropulse/features/measure/data/repositories/measurement_repository_impl.dart';
import 'package:nuropulse/services/dsp_config_loader.dart';
import 'package:nuropulse/services/logger_service.dart';
import 'package:nuropulse/services/storage/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = LoggerService();
  final hive = HiveService();
  await hive.init();
  final dspConfig = await DspConfigLoader.load();

  if (!dspConfig.calibrated) {
    logger.warning('DSP thresholds are not calibrated');
  }

  final measurementRepository = MeasurementRepositoryImpl(
    SensorDatasource(),
    MeasurementLocalDatasource(hive),
    dspConfig,
  );

  runApp(
    App(
      logger: logger,
      measurementRepository: measurementRepository,
      dspConfig: dspConfig,
    ),
  );
}
