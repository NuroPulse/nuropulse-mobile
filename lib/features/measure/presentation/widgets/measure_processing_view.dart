import 'package:flutter/material.dart';
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
          const CircularProgressIndicator(color: BaseColors.primary),
          const SizedBox(height: 16),
          Text(
            'Memproses…',
            style: FontTheme.bodyLg.copyWith(color: BaseColors.ink),
          ),
        ],
      ),
    );
  }
}
