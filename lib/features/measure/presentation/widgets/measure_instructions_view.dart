import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/app_alert.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/app_dropdown.dart';
import 'package:nuropulse/core/widgets/app_step_indicator.dart';
import 'package:nuropulse/features/measure/presentation/cubit/measure_cubit.dart';

const _stepLabels = [
  'Cari posisi duduk yang nyaman, dengan lengan bawah tersangga di atas meja atau pangkuan.',
  'Letakkan ponsel di punggung tangan Anda, pegang erat atau gunakan forearm strap (jika tersedia) agar tidak bergeser.',
  'Biarkan tangan rileks dan diam. Jangan sentuh layar selama perekaman berlangsung.',
];

const _durationOptions = [10, 15, 20, 25, 30];

/// "Instructions" in the user flow: shown while the
/// cubit is idle, before the countdown. Walks through prep steps, then lets
/// the user pick a duration and start.
class MeasureInstructionsView extends StatefulWidget {
  const MeasureInstructionsView({super.key});

  @override
  State<MeasureInstructionsView> createState() =>
      _MeasureInstructionsViewState();
}

class _MeasureInstructionsViewState extends State<MeasureInstructionsView> {
  int _step = 0;
  int _durationSeconds = 20;

  bool get _isLastStep => _step == _stepLabels.length - 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BaseColors.focus),
              boxShadow: [
                BoxShadow(
                  color: BaseColors.inkMuted.withValues(alpha: 0.5),
                  blurRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // radius-md
              child: Image.asset(
                'assets/images/nuropulse-instruction.jpg',
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppStepIndicator(
            current: _step + 1,
            total: _stepLabels.length,
            labels: _stepLabels,
          ),
          const SizedBox(height: 24),
          if (!_isLastStep)
            const AppAlert(
              tone: AppAlertTone.info,
              message:
                  'Jangan ada getaran, suara, atau sentuhan yang menggerakkan '
                  'ponsel selama perekaman berlangsung.',
            ),
          if (_isLastStep) ...[
            Text(
              'Durasi perekaman',
              textAlign: TextAlign.center,
              style: FontTheme.heading.copyWith(color: BaseColors.ink),
            ),
            AppDropdown<int>(
              label: '',
              value: _durationSeconds,
              items: [
                for (final seconds in _durationOptions)
                  AppDropdownItem(value: seconds, label: '$seconds detik'),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _durationSeconds = value);
              },
            ),
          ],
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  icon: Icons.arrow_back_ios_rounded,
                  label: 'Back',
                  variant: AppButtonVariant.secondary,
                  onPressed: _step > 0 ? () => setState(() => _step--) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  icon: Icons.arrow_forward_ios_rounded,
                  iconPosition: AppButtonIconPosition.trailing,
                  label: _isLastStep ? 'Start' : 'Next',
                  onPressed: () {
                    if (_isLastStep) {
                      context.read<MeasureCubit>().start(
                        recordingDuration: Duration(seconds: _durationSeconds),
                      );
                    } else {
                      setState(() => _step++);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
