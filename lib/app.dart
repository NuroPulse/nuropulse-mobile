import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/app_theme.dart';
import 'package:nuropulse/dsp/dsp_config.dart';
import 'package:nuropulse/features/auth/domain/repositories/auth_repository.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nuropulse/features/connection/domain/repositories/connection_repository.dart';
import 'package:nuropulse/features/connection/presentation/cubit/connection_cubit.dart';
import 'package:nuropulse/features/measure/domain/repositories/measurement_repository.dart';
import 'package:nuropulse/features/medication/domain/repositories/medication_repository.dart';
import 'package:nuropulse/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:nuropulse/services/logger_service.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.logger,
    required this.measurementRepository,
    required this.dspConfig,
    required this.onboardingRepository,
    required this.authRepository,
    required this.connectionRepository,
    required this.medicationRepository,
    required this.router,
  });

  final LoggerService logger;
  final MeasurementRepository measurementRepository;
  final DspConfig dspConfig;
  final OnboardingRepository onboardingRepository;
  final AuthRepository authRepository;
  final ConnectionRepository connectionRepository;
  final MedicationRepository medicationRepository;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MeasurementRepository>.value(
          value: measurementRepository,
        ),
        RepositoryProvider<DspConfig>.value(value: dspConfig),
        RepositoryProvider<OnboardingRepository>.value(
          value: onboardingRepository,
        ),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<ConnectionRepository>.value(
          value: connectionRepository,
        ),
        RepositoryProvider<MedicationRepository>.value(
          value: medicationRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                ConnectionCubit(context.read<ConnectionRepository>()),
          ),
        ],
        child: MaterialApp.router(
          title: 'NuroPulse',
          theme: AppTheme.light,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
