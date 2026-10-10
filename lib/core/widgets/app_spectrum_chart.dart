import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/utils/number_format.dart';
import 'package:nuropulse/dsp/models/spectrum.dart';

/// Power spectral density for one check, with the tremor band (CLAUDE.md
/// section 10) shaded and the detected peak marked. One series only — color
/// stays the brand primary throughout; no legend needed, the heading above
/// this chart names it.
///
/// The visible range is clipped to [peakSearchHz] — that is the whole range
/// `peakFrequencyHz` is ever chosen from, so nothing outside it is shown.
class AppSpectrumChart extends StatelessWidget {
  const AppSpectrumChart({
    super.key,
    required this.spectrum,
    required this.tremorBandHz,
    required this.peakSearchHz,
    required this.peakFrequencyHz,
  });

  final Spectrum spectrum;
  final (double, double) tremorBandHz;
  final (double, double) peakSearchHz;
  final double peakFrequencyHz;

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    var maxY = 0.0;
    for (var i = 0; i < spectrum.frequencies.length; i++) {
      final f = spectrum.frequencies[i];
      if (f < peakSearchHz.$1) continue; // frequencies are sorted ascending
      if (f > peakSearchHz.$2) break;
      final p = spectrum.power[i];
      spots.add(FlSpot(f, p));
      if (p > maxY) maxY = p;
    }
    if (maxY == 0) maxY = 1;

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minX: peakSearchHz.$1,
          maxX: peakSearchHz.$2,
          minY: 0,
          maxY: maxY * 1.2,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: maxY / 2,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: BaseColors.line, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: (peakSearchHz.$2 - peakSearchHz.$1) / 3,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${value.toStringAsFixed(0)} Hz',
                    style: FontTheme.caption.copyWith(
                      color: BaseColors.inkMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
          rangeAnnotations: RangeAnnotations(
            verticalRangeAnnotations: [
              VerticalRangeAnnotation(
                x1: tremorBandHz.$1,
                x2: tremorBandHz.$2,
                color: BaseColors.dangerSoft,
              ),
            ],
          ),
          extraLinesData: ExtraLinesData(
            verticalLines: [
              VerticalLine(
                x: peakFrequencyHz,
                color: BaseColors.ink,
                strokeWidth: 1.5,
                dashArray: const [4, 4],
                label: VerticalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  style: FontTheme.caption.copyWith(
                    color: BaseColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                  labelResolver: (_) =>
                      '${formatNumber(peakFrequencyHz, 2)} Hz',
                ),
              ),
            ],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => BaseColors.ink,
              getTooltipItems: (touchedSpots) => [
                for (final spot in touchedSpots)
                  LineTooltipItem(
                    '${formatNumber(spot.x, 1)} Hz',
                    FontTheme.caption.copyWith(color: BaseColors.surface),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: BaseColors.secondary500,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
