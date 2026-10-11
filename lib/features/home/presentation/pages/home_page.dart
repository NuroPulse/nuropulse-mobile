import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/utils/date_format.dart';
import 'package:nuropulse/core/utils/number_format.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/dsp/models/tremor_status.dart';
import 'package:nuropulse/features/history/presentation/cubit/history_cubit.dart';
import 'package:nuropulse/features/history/presentation/cubit/history_state.dart';
import 'package:nuropulse/features/measure/domain/entity/measurement_record.dart';

/// Home tab: a summary of the last check plus the entry point into a new
/// one. Reads the [HistoryCubit] provided above the home shell, and
/// refreshes it whenever a measure run finishes and control returns here.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(showLogo: true, label: 'NuroPulse'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengecekan terakhir',
              style: FontTheme.heading.copyWith(color: BaseColors.ink),
            ),
            const SizedBox(height: 12),
            const _LastCheckCard(),
            const Spacer(),
            AppButton(
              label: 'Mulai Cek Tremor',
              icon: Icons.favorite_border,
              onPressed: () async {
                await context.push('/measure');
                if (context.mounted) context.read<HistoryCubit>().load();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LastCheckCard extends StatelessWidget {
  const _LastCheckCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors.surfaceRaised,
        border: Border.all(color: BaseColors.line),
        borderRadius: BorderRadius.circular(20), // radius-lg
      ),
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          return switch (state) {
            HistoryLoading() => const SizedBox(
              height: 40,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            HistoryFailure() => Column(
              children: [
                Icon(
                  Icons.monitor_heart_outlined,
                  size: 40,
                  color: BaseColors.inkMuted,
                ),
                const SizedBox(height: 12),
                Text(
                  'Gagal memuat ringkasan',
                  textAlign: TextAlign.center,
                  style: FontTheme.bodyLg.copyWith(color: BaseColors.ink),
                ),
              ],
            ),
            HistoryLoaded(:final records) when records.isEmpty => Column(
              children: [
                Icon(
                  Icons.monitor_heart_outlined,
                  size: 40,
                  color: BaseColors.inkMuted,
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada riwayat pengecekan',
                  textAlign: TextAlign.center,
                  style: FontTheme.bodyLg.copyWith(color: BaseColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mulai cek pertama Anda untuk melihat ringkasannya di sini.',
                  textAlign: TextAlign.center,
                  style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
                ),
              ],
            ),
            HistoryLoaded(:final records) => _LastCheckSummary(
              record: records.first,
            ),
          };
        },
      ),
    );
  }
}

class _LastCheckSummary extends StatelessWidget {
  const _LastCheckSummary({required this.record});

  final MeasurementRecord record;

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (record.status) {
      TremorStatus.tremor => (
        BaseColors.danger,
        Icons.error_outline,
        'Tremor terdeteksi',
      ),
      TremorStatus.none => (
        BaseColors.success,
        Icons.check_circle_outline,
        'Tidak terdeteksi',
      ),
      TremorStatus.invalid => (
        BaseColors.warning,
        Icons.warning_amber_rounded,
        'Tidak valid',
      ),
    };

    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: FontTheme.bodyLg.copyWith(
            color: BaseColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatDateTime(record.measuredAt),
          textAlign: TextAlign.center,
          style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
        ),
        if (record.peakFrequencyHz != null) ...[
          const SizedBox(height: 4),
          Text(
            '${formatNumber(record.peakFrequencyHz as double, 1)} Hz',
            textAlign: TextAlign.center,
            style: FontTheme.label.copyWith(color: BaseColors.inkMuted),
          ),
        ],
      ],
    );
  }
}
