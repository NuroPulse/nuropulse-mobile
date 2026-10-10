import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/utils/number_format.dart';
import 'package:nuropulse/core/widgets/app_feature_table.dart';
import 'package:nuropulse/core/widgets/app_gate_list.dart';
import 'package:nuropulse/core/widgets/app_spectrum_chart.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/dsp/dsp_config.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';

/// Full breakdown of one finished check, reached from "Lihat Detail" on the
/// result screen. Not the diagnosis itself — just the numbers behind it.
class MeasureDetailPage extends StatelessWidget {
  const MeasureDetailPage({super.key, required this.result});

  final TremorResult result;

  @override
  Widget build(BuildContext context) {
    final features = result.features;
    final debug = result.debug;
    final qc = result.qc;
    final config = context.read<DspConfig>();

    return Scaffold(
      appBar: const MainAppBar(label: 'Detail Pengecekan'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (debug != null && features != null) ...[
            Text(
              'Spektrum frekuensi',
              style: FontTheme.heading.copyWith(color: BaseColors.ink),
            ),
            const SizedBox(height: 8),
            AppSpectrumChart(
              spectrum: debug.spectrum,
              tremorBandHz: config.tremorBandHz,
              peakSearchHz: config.peakSearchHz,
              peakFrequencyHz: features.peakFrequencyHz,
            ),
            const SizedBox(height: 32),
          ],
          if (features != null) ...[
            Text(
              'Fitur sinyal',
              style: FontTheme.heading.copyWith(color: BaseColors.ink),
            ),
            const SizedBox(height: 8),
            AppFeatureTable(features: features),
            const SizedBox(height: 32),
          ],
          Text(
            'Pemeriksaan kualitas',
            style: FontTheme.heading.copyWith(color: BaseColors.ink),
          ),
          const SizedBox(height: 8),
          AppGateList(gates: result.gates),
          const SizedBox(height: 32),
          Text(
            'Info sampling',
            style: FontTheme.heading.copyWith(color: BaseColors.ink),
          ),
          const SizedBox(height: 8),
          Text(
            'Kecepatan sampling efektif: ${formatNumber(qc.effectiveFsHz, 1)} Hz\n'
            'Jitter: ${formatNumber(qc.jitter, 3)}\n'
            'Jeda maksimum: ${formatNumber(qc.maxGapMs, 0)} ms',
            style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
          ),
        ],
      ),
    );
  }
}
