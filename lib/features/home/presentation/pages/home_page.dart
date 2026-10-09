import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/app_text_field.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 10,
            children: [
              AppButton(label: "Down the Waterline", onPressed: () => {}),
              AppTextField(
                label: "Great Gig in the Sky",
                hint: "There is no dark side of the moon",
                placeholder: "Ex: Pink Floyd",
              ),
              AppTextField(
                label: "Duvet",
                unit: "tahun",
                prefixIcon: Icon(Icons.accessibility_sharp),
              ),
              AppTextField(
                label: "Catch the Rainbow",
                prefixIcon: Icon(Icons.accessibility_sharp),
                obscureText: true,
              ),
              AppButton(
                label: "Nikola Tesla",
                onPressed: () => {},
                variant: AppButtonVariant.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
