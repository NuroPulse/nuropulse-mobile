import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/utils/number_format.dart';
import 'package:nuropulse/dsp/models/tremor_features.dart';

/// Standard gravity, m/s² — display-only conversion of `bandRms` (CLAUDE.md
/// section 10: this conversion never belongs inside lib/dsp/).
const _gravityMs2 = 9.80665;

/// Label + value breakdown of one check's [TremorFeatures], for a detail
/// screen (not the design system — no Feature Table component there).
class AppFeatureTable extends StatelessWidget {
  const AppFeatureTable({super.key, required this.features});

  final TremorFeatures features;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Frekuensi puncak', '${formatNumber(features.peakFrequencyHz, 2)} Hz'),
      ('Rasio daya pita', formatNumber(features.bandPowerRatio, 3)),
      ('Rasio sinyal-noise', formatNumber(features.snr, 2)),
      (
        'Amplitudo (RMS)',
        '${formatNumber(features.bandRms / _gravityMs2, 4)} g',
      ),
      ('Konsistensi', formatNumber(features.consistency, 2)),
    ];

    return Column(
      children: [
        for (final (label, value) in rows)
          Padding(
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
          ),
      ],
    );
  }
}
