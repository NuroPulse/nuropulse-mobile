import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/app_alert.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/features/measure/domain/entity/invalid_reason.dart';
import 'package:nuropulse/features/measure/presentation/cubit/measure_cubit.dart';

/// `MeasureState.invalid`. The headline is the fixed decision wording
/// each [reasons] entry is shown below as detail.
class MeasureInvalidView extends StatelessWidget {
  const MeasureInvalidView({super.key, required this.reasons});

  final List<InvalidReason> reasons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppAlert(
            tone: AppAlertTone.warning,
            message: 'Pengukuran tidak valid. Silakan ulangi.',
          ),
          if (reasons.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Penyebab',
              style: FontTheme.label.copyWith(color: BaseColors.ink),
            ),
            const SizedBox(height: 8),
            for (final reason in reasons)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '•  ${_reasonText(reason)}',
                  style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
                ),
              ),
          ],
          const Spacer(),
          AppButton(
            label: 'Ulangi',
            onPressed: () => context.read<MeasureCubit>().retry(),
          ),
        ],
      ),
    );
  }

  static String _reasonText(InvalidReason reason) {
    return switch (reason) {
      InvalidReason.sampling => 'Kecepatan sampling sensor terlalu rendah',
      InvalidReason.dataGap => 'Ada jeda data yang terlalu panjang',
      InvalidReason.tooShort => 'Rekaman terlalu pendek untuk dianalisis',
      InvalidReason.flatSignal => 'Sensor tidak mendeteksi gerakan sama sekali',
      InvalidReason.interrupted =>
        'Rekaman dihentikan karena aplikasi keluar dari layar.',
    };
  }
}
