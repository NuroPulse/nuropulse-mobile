import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/app_alert.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/app_step_indicator.dart';
import 'package:nuropulse/core/widgets/app_text_field.dart';
import 'package:nuropulse/core/widgets/app_toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currIndicator = 1;
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
              AppButton(
                label: "Down the Waterline",
                onPressed: () => {
                  showAppToast(
                    context,
                    message:
                        "What a Fool Believes from the album Minute by Minute by The Doobie Brothers",
                    tone: AppToastTone.danger,
                  ),
                },
              ),
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
                onPressed: () => {
                  showAppToast(
                    context,
                    message: "Serenata Jiwa yang Lara Sunyi",
                  ),
                },
                variant: AppButtonVariant.outline,
              ),
              AppAlert(
                title: "Sakura Abadi",
                message: "Hujan datang turun membasahi",
                tone: AppAlertTone.danger,
              ),
              AppStepIndicator(
                current: currIndicator,
                total: 4,
                labels: ["What", "Reminiscense", "What", "What"],
              ),
              AppButton(
                label: ">",
                onPressed: () => {
                  setState(() {
                    if (currIndicator < 4) currIndicator++;
                  }),
                },
              ),
              AppButton(
                label: "<",
                onPressed: () => {
                  setState(() {
                    if (currIndicator > 1) currIndicator--;
                  }),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
