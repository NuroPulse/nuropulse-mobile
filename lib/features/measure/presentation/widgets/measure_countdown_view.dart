import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/features/measure/presentation/cubit/measure_cubit.dart';

class MeasureCountdownView extends StatelessWidget {
  const MeasureCountdownView({
    super.key,
    required this.secondsLeft,
    this.totalSeconds = 3,
  });

  final int secondsLeft;

  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Text(
            'Silakan bersiap...',
            textAlign: TextAlign.center,
            style: FontTheme.bodyLg.copyWith(
              color: BaseColors.secondary900,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: secondsLeft / totalSeconds),
                    duration: const Duration(seconds: 1),
                    curve: Curves.linear,
                    builder: (context, value, child) =>
                        CircularProgressIndicator(
                          value: value,
                          strokeWidth: 14,
                          strokeCap: StrokeCap.round,
                          backgroundColor: BaseColors.line,
                          valueColor: const AlwaysStoppedAnimation(
                            BaseColors.secondary500,
                          ),
                        ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: '$secondsLeft',
                    style: FontTheme.data.copyWith(
                      fontSize: 72,
                      height: 1,
                      color: BaseColors.ink,
                    ),
                    children: [
                      TextSpan(
                        text: 's',
                        style: FontTheme.data.copyWith(
                          fontSize: 28,
                          color: BaseColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          AppButton(
            label: 'Batal',
            variant: AppButtonVariant.text,
            icon: Icons.cancel_outlined,
            onPressed: () => context.read<MeasureCubit>().cancel(),
          ),
        ],
      ),
    );
  }
}
