import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

class MeasureProcessingView extends StatelessWidget {
  const MeasureProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset("assets/lotties/pulse.lottie", width: 160),
          const SizedBox(height: 8),
          Text(
            'Memproses...',
            style: FontTheme.bodyLg.copyWith(
              color: BaseColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
