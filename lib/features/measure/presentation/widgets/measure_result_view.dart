import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/utils/number_format.dart';
import 'package:nuropulse/core/widgets/app_alert.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
// import 'package:nuropulse/dsp/dsp_config.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';
import 'package:nuropulse/dsp/models/tremor_status.dart';
import 'package:nuropulse/features/measure/presentation/cubit/measure_cubit.dart';

/// `MeasureState.success` — status is always `none` or `tremor` here
/// (`invalid` has its own view). Wording is fixed by CLAUDE.md section 8:
/// never implies a diagnosis.
class MeasureResultView extends StatelessWidget {
  const MeasureResultView({super.key, required this.result});

  final TremorResult result;

  @override
  Widget build(BuildContext context) {
    // final calibrated = context.read<DspConfig>().calibrated;
    final isTremor = result.status == TremorStatus.tremor;
    final features = result.features!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              isTremor
                  ? 'assets/images/result-tremor.png'
                  : 'assets/images/result-none.png',
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          // if (!calibrated) ...[
          //   const AppAlert(
          //     tone: AppAlertTone.warning,
          //     message: 'Ambang belum dikalibrasi',
          //   ),
          //   const SizedBox(height: 16),
          // ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Frekuensi dominan',
                  style: FontTheme.label.copyWith(color: BaseColors.inkMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatNumber(features.peakFrequencyHz, 1)} Hz',
                  style: FontTheme.data.copyWith(color: BaseColors.ink),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AppAlert(
            tone: isTremor ? AppAlertTone.danger : AppAlertTone.success,
            message: isTremor
                ? 'Tremor ritmis terdeteksi. Sebaiknya konsultasikan dengan dokter saraf.'
                : 'Tremor ritmis tidak terdeteksi pada pengecekan ini. Jika Anda tetap khawatir, konsultasikan dengan dokter.',
          ),
          const Spacer(),
          AppButton(
            icon: Icons.monitor_heart,
            label: 'Lihat Detail',
            variant: AppButtonVariant.text,
            onPressed: () => context.push('/measure/detail', extra: result),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Ulangi',
            icon: Icons.restart_alt,
            onPressed: () => context.read<MeasureCubit>().retry(),
          ),
        ],
      ),
    );
  }
}
