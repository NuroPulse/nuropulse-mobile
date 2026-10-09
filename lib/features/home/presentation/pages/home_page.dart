import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NuroPulse",
          style: FontTheme.heading.copyWith(color: BaseColors.onPrimary),
        ),
        backgroundColor: BaseColors.primary,
      ),
      body: Center(
        child: Text(
          "Bismillah Juara 1",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
