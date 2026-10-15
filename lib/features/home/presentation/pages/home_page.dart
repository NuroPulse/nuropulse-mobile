import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/utils/date_format.dart';
import 'package:nuropulse/core/utils/greeting.dart';
import 'package:nuropulse/core/utils/number_format.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/dsp/dsp_config.dart';
import 'package:nuropulse/dsp/models/tremor_status.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:nuropulse/features/history/presentation/cubit/history_cubit.dart';
import 'package:nuropulse/features/history/presentation/cubit/history_state.dart';
import 'package:nuropulse/features/measure/domain/entity/measurement_record.dart';

/// Home tab: a greeting, a summary of the last check, a frequency trend,
/// and the entry point into a new check. Reads the [HistoryCubit] provided
/// above the home shell, and refreshes it whenever a measure run finishes
/// and control returns here.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(showLogo: true, label: 'NuroPulse'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Greeting(),
            const SizedBox(height: 4),
            Text(
              'Pantau tremor Anda secara rutin dari sini.',
              style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
            ),
            const SizedBox(height: 28),
            Text(
              'Pengecekan terakhir',
              style: FontTheme.heading.copyWith(color: BaseColors.ink),
            ),
            const SizedBox(height: 12),
            const _LastCheckCard(),
            const SizedBox(height: 24),
            const _PeakFrequencyTrendCard(),
            const SizedBox(height: 28),
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

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final greeting = greetingForHour(DateTime.now().hour);
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final firstName = state is AuthAuthenticated
            ? state.profile.fullName.split(' ').first
            : null;
        return Text(
          firstName == null ? '$greeting!' : '$greeting, $firstName!',
          style: FontTheme.title.copyWith(color: BaseColors.ink),
        );
      },
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

/// Peak frequency across the last few valid checks, oldest to newest, with
/// the tremor band (same range as the detail screen's spectrum chart)
/// shaded for reference. Hidden until there are at least two valid points.
class _PeakFrequencyTrendCard extends StatelessWidget {
  const _PeakFrequencyTrendCard();

  static const _maxPoints = 10;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is! HistoryLoaded) return const SizedBox.shrink();

        final valid = [
          for (final record in state.records)
            if (record.peakFrequencyHz != null) record,
        ];
        // records are newest first; the chart reads oldest to newest.
        final recent =
            (valid.length > _maxPoints ? valid.sublist(0, _maxPoints) : valid)
                .reversed
                .toList();
        if (recent.length < 2) return const SizedBox.shrink();

        final tremorBand = context.read<DspConfig>().tremorBandHz;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: BaseColors.surfaceRaised,
            border: Border.all(color: BaseColors.line),
            borderRadius: BorderRadius.circular(20), // radius-lg
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tren frekuensi puncak',
                style: FontTheme.label.copyWith(color: BaseColors.inkMuted),
              ),
              const SizedBox(height: 4),
              Text(
                '${recent.length} pengecekan terakhir',
                style: FontTheme.caption.copyWith(color: BaseColors.inkMuted),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 15,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    lineTouchData: const LineTouchData(enabled: false),
                    rangeAnnotations: RangeAnnotations(
                      horizontalRangeAnnotations: [
                        HorizontalRangeAnnotation(
                          y1: tremorBand.$1,
                          y2: tremorBand.$2,
                          color: BaseColors.primarySoft,
                        ),
                      ],
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < recent.length; i++)
                            FlSpot(i.toDouble(), recent[i].peakFrequencyHz!),
                        ],
                        isCurved: true,
                        color: BaseColors.chart1,
                        barWidth: 2,
                        dotData: FlDotData(
                          getDotPainter: (spot, percent, bar, index) =>
                              FlDotCirclePainter(
                                radius: 3,
                                color: BaseColors.chart1,
                                strokeWidth: 0,
                              ),
                        ),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
