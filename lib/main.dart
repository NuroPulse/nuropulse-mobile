import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nuropulse/app.dart';
import 'package:nuropulse/core/environments/env.dart';
import 'package:nuropulse/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nuropulse/features/auth/data/datasources/profile_remote_datasource.dart';
import 'package:nuropulse/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nuropulse/features/connection/data/datasources/connection_remote_datasource.dart';
import 'package:nuropulse/features/connection/data/repositories/connection_repository_impl.dart';
import 'package:nuropulse/features/measure/data/datasources/measurement_local_datasource.dart';
import 'package:nuropulse/features/measure/data/datasources/sensor_datasource.dart';
import 'package:nuropulse/features/measure/data/repositories/measurement_repository_impl.dart';
import 'package:nuropulse/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:nuropulse/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:nuropulse/services/dsp_config_loader.dart';
import 'package:nuropulse/services/logger_service.dart';
import 'package:nuropulse/services/router_service.dart';
import 'package:nuropulse/services/storage/hive_service.dart';
import 'package:nuropulse/services/storage/secure_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
    authOptions: FlutterAuthClientOptions(localStorage: SecureStorageService()),
  );

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
  final onboardingRepository = OnboardingRepositoryImpl(
    OnboardingLocalDatasource(hive),
  );
  final authRepository = AuthRepositoryImpl(
    AuthRemoteDatasource(Supabase.instance.client),
    ProfileRemoteDatasource(Supabase.instance.client),
  );
  final connectionRepository = ConnectionRepositoryImpl(
    ConnectionRemoteDatasource(Supabase.instance.client),
  );

  runApp(
    App(
      logger: logger,
      measurementRepository: measurementRepository,
      dspConfig: dspConfig,
      onboardingRepository: onboardingRepository,
      authRepository: authRepository,
      connectionRepository: connectionRepository,
      router: createRouter(onboardingRepository: onboardingRepository),
    ),
  );
}
