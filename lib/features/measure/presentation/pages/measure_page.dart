import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/features/measure/domain/repositories/measurement_repository.dart';
import 'package:nuropulse/features/measure/presentation/cubit/measure_cubit.dart';
import 'package:nuropulse/features/measure/presentation/cubit/measure_state.dart';
import 'package:nuropulse/features/measure/presentation/widgets/measure_countdown_view.dart';
import 'package:nuropulse/features/measure/presentation/widgets/measure_failure_view.dart';
import 'package:nuropulse/features/measure/presentation/widgets/measure_instructions_view.dart';
import 'package:nuropulse/features/measure/presentation/widgets/measure_invalid_view.dart';
import 'package:nuropulse/features/measure/presentation/widgets/measure_processing_view.dart';
import 'package:nuropulse/features/measure/presentation/widgets/measure_recording_view.dart';
import 'package:nuropulse/features/measure/presentation/widgets/measure_result_view.dart';

class MeasurePage extends StatelessWidget {
  const MeasurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeasureCubit(context.read<MeasurementRepository>()),
      child: const _MeasureView(),
    );
  }
}

class _MeasureView extends StatefulWidget {
  const _MeasureView();

  @override
  State<_MeasureView> createState() => _MeasureViewState();
}

class _MeasureViewState extends State<_MeasureView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<MeasureCubit>().interrupt();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(label: 'Cek Tremor'),
      body: SafeArea(
        child: BlocBuilder<MeasureCubit, MeasureState>(
          builder: (context, state) {
            return switch (state) {
              MeasureIdle() => const MeasureInstructionsView(),
              MeasureCountdown(:final secondsLeft) => MeasureCountdownView(
                secondsLeft: secondsLeft,
              ),
              MeasureRecording(
                :final elapsed,
                :final totalDuration,
                :final window,
              ) =>
                MeasureRecordingView(
                  elapsed: elapsed,
                  totalDuration: totalDuration,
                  window: window,
                ),
              MeasureProcessing() => const MeasureProcessingView(),
              MeasureSuccess(:final result) => MeasureResultView(
                result: result,
              ),
              MeasureInvalid(:final reasons) => MeasureInvalidView(
                reasons: reasons,
              ),
              MeasureFailure(:final failure) => MeasureFailureView(
                failure: failure,
              ),
            };
          },
        ),
      ),
    );
  }
}
