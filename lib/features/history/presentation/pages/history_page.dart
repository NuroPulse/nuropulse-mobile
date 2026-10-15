import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/utils/date_format.dart';
import 'package:nuropulse/core/utils/number_format.dart';
import 'package:nuropulse/core/widgets/app_alert.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/dsp/models/tremor_status.dart';
import 'package:nuropulse/features/history/presentation/cubit/history_cubit.dart';
import 'package:nuropulse/features/history/presentation/cubit/history_state.dart';
import 'package:nuropulse/features/measure/domain/entity/measurement_record.dart';

/// Riwayat tab: every saved check, most recent first. Reads the
/// [HistoryCubit] provided above the home shell, so it stays in sync with
/// whatever the home dashboard's "last check" card last loaded.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(label: 'Riwayat', showLogo: true),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          return switch (state) {
            HistoryLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            HistoryFailure() => Padding(
              padding: const EdgeInsets.all(24),
              child: AppAlert(
                tone: AppAlertTone.danger,
                message: 'Terjadi kesalahan. Silakan coba lagi.',
                action: TextButton(
                  onPressed: () => context.read<HistoryCubit>().load(),
                  child: const Text('Muat ulang'),
                ),
              ),
            ),
            HistoryLoaded(:final records) =>
              records.isEmpty
                  ? const _EmptyState()
                  : RefreshIndicator(
                      onRefresh: () => context.read<HistoryCubit>().load(),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(24),
                        itemCount: records.length + 1,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _SummaryHeader(count: records.length);
                          }
                          return _HistoryTile(record: records[index - 1]);
                        },
                      ),
                    ),
          };
        },
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$count pengecekan tercatat',
        style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 56, color: BaseColors.inkMuted),
            const SizedBox(height: 16),
            Text(
              'Belum ada riwayat pengecekan',
              textAlign: TextAlign.center,
              style: FontTheme.heading.copyWith(color: BaseColors.ink),
            ),
            const SizedBox(height: 8),
            Text(
              'Hasil pengecekan Anda akan muncul di sini.',
              textAlign: TextAlign.center,
              style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.record});

  final MeasurementRecord record;

  @override
  Widget build(BuildContext context) {
    final (color, softColor, icon, label) = switch (record.status) {
      TremorStatus.tremor => (
        BaseColors.danger,
        BaseColors.dangerSoft,
        Icons.error_outline,
        'Tremor terdeteksi',
      ),
      TremorStatus.none => (
        BaseColors.success,
        BaseColors.successSoft,
        Icons.check_circle_outline,
        'Tidak terdeteksi',
      ),
      TremorStatus.invalid => (
        BaseColors.warning,
        BaseColors.warningSoft,
        Icons.warning_amber_rounded,
        'Tidak valid',
      ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BaseColors.surfaceRaised,
        border: Border.all(color: BaseColors.line),
        borderRadius: BorderRadius.circular(12), // radius-md
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: softColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: FontTheme.bodyLg.copyWith(
                    color: BaseColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatDateTime(record.measuredAt),
                  style: FontTheme.caption.copyWith(color: BaseColors.inkMuted),
                ),
              ],
            ),
          ),
          if (record.peakFrequencyHz != null)
            Text(
              '${formatNumber(record.peakFrequencyHz!, 1)} Hz',
              style: FontTheme.label.copyWith(color: BaseColors.ink),
            ),
        ],
      ),
    );
  }
}
