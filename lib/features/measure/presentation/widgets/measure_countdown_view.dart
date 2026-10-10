import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/features/measure/presentation/cubit/measure_cubit.dart';

class MeasureCountdownView extends StatelessWidget {
  const MeasureCountdownView({super.key, required this.secondsLeft});

  final int secondsLeft;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Text(
            'Bersiap… mulai dalam $secondsLeft detik',
            textAlign: TextAlign.center,
            style: FontTheme.bodyLg.copyWith(color: BaseColors.ink),
          ),
          const SizedBox(height: 16),
          Text(
            '$secondsLeft',
            style: FontTheme.data.copyWith(
              fontSize: 96,
              height: 1,
              color: BaseColors.primary,
            ),
          ),
          const Spacer(),
          AppButton(
            label: 'Batal',
            variant: AppButtonVariant.text,
            onPressed: () => context.read<MeasureCubit>().cancel(),
          ),
        ],
      ),
    );
  }
}
