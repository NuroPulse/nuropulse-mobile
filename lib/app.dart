import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/themes/app_theme.dart';
import 'package:nuropulse/dsp/dsp_config.dart';
import 'package:nuropulse/features/measure/domain/repositories/measurement_repository.dart';
import 'package:nuropulse/services/logger_service.dart';
import 'package:nuropulse/services/router_service.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.logger,
    required this.measurementRepository,
    required this.dspConfig,
  });

  final LoggerService logger;
  final MeasurementRepository measurementRepository;
  final DspConfig dspConfig;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MeasurementRepository>.value(
          value: measurementRepository,
        ),
        RepositoryProvider<DspConfig>.value(value: dspConfig),
      ],
      child: MaterialApp.router(
        title: 'NuroPulse',
        theme: AppTheme.light,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
