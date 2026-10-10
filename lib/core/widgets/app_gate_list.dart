import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/dsp/models/gate_check.dart';
import 'package:nuropulse/dsp/models/gate_result.dart';

/// Pass/fail per quality-gate check, for a detail screen. Labels name what
/// is being checked, not the failure sentence — compare
/// AppTextField/AppAlert's error wording, which does use the failure form.
class AppGateList extends StatelessWidget {
  const AppGateList({super.key, required this.gates});

  final List<GateResult> gates;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final gate in gates)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(
                  gate.passed
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
                  color: gate.passed ? BaseColors.success : BaseColors.danger,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  _label(gate.check),
                  style: FontTheme.body.copyWith(color: BaseColors.ink),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static String _label(GateCheck check) {
    return switch (check) {
      GateCheck.sampling => 'Kecepatan sampling',
      GateCheck.dataGap => 'Jeda data',
      GateCheck.tooShort => 'Panjang rekaman',
      GateCheck.flatSignal => 'Variasi sinyal',
    };
  }
}
