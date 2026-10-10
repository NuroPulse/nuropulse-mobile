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
            _DetailCard(
              title: 'Spektrum frekuensi',
              child: AppSpectrumChart(
                spectrum: debug.spectrum,
                tremorBandHz: config.tremorBandHz,
                peakSearchHz: config.peakSearchHz,
                peakFrequencyHz: features.peakFrequencyHz,
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (features != null) ...[
            _DetailCard(
              title: 'Fitur sinyal',
              child: AppFeatureTable(features: features),
            ),
            const SizedBox(height: 20),
          ],
          _DetailCard(
            title: 'Pemeriksaan kualitas',
            child: AppGateList(gates: result.gates),
          ),
          const SizedBox(height: 20),
          _DetailCard(
            title: 'Info sampling',
            child: Column(
              children: [
                _InfoRow(
                  label: 'Kecepatan sampling efektif',
                  value: '${formatNumber(qc.effectiveFsHz, 1)} Hz',
                ),
                _InfoRow(label: 'Jitter', value: formatNumber(qc.jitter, 3)),
                _InfoRow(
                  label: 'Jeda maksimum',
                  value: '${formatNumber(qc.maxGapMs, 0)} ms',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Groups one section's heading and content into a visually distinct panel,
/// instead of headings and content floating directly on the scaffold.
class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors.surfaceRaised,
        border: Border.all(color: BaseColors.line),
        borderRadius: BorderRadius.circular(20), // radius-lg
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: FontTheme.heading.copyWith(color: BaseColors.ink)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
            ),
          ),
          Text(
            value,
            style: FontTheme.bodyLg.copyWith(
              color: BaseColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
