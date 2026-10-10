import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/core/widgets/app_alert.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/features/measure/presentation/cubit/measure_cubit.dart';

/// `MeasureState.failure`. [failure] is never shown to the user — only the
/// generic message (CLAUDE.md section 7); [failure.message] is for logs.
class MeasureFailureView extends StatelessWidget {
  const MeasureFailureView({super.key, required this.failure});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppAlert(
            tone: AppAlertTone.danger,
            message: 'Terjadi kesalahan. Silakan coba lagi.',
          ),
          const Spacer(),
          AppButton(
            label: 'Ulangi',
            onPressed: () => context.read<MeasureCubit>().retry(),
          ),
        ],
      ),
    );
  }
}
