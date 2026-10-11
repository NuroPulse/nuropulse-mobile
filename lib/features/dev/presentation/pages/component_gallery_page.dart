import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/widgets/app_alert.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/app_dropdown.dart';
import 'package:nuropulse/core/widgets/app_step_indicator.dart';
import 'package:nuropulse/core/widgets/app_text_field.dart';
import 'package:nuropulse/core/widgets/app_toast.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';

/// Dev-only scratchpad for eyeballing design-system components together.
/// Not part of the real app flow — reached from `/debug/kitchen-sink`.
class ComponentGalleryPage extends StatefulWidget {
  const ComponentGalleryPage({super.key});

  @override
  State<ComponentGalleryPage> createState() => _ComponentGalleryPageState();
}

class _ComponentGalleryPageState extends State<ComponentGalleryPage> {
  int currIndicator = 1;
  int? selectedDuration;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(showLogo: true, label: "NuroPulse"),
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
              SizedBox(
                height: 64,
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: AppButton(
                        label: "<",
                        onPressed: () {
                          setState(() {
                            if (currIndicator > 1) currIndicator--;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        label: ">",
                        onPressed: () => {
                          setState(() {
                            if (currIndicator < 4) currIndicator++;
                          }),
                        },
                      ),
                    ),
                  ],
                ),
              ),

              AppDropdown<int>(
                label: "Durasi perekaman",
                placeholder: "Pilih durasi",
                hint: "Literatur memakai 20–30 detik per rekaman.",
                value: selectedDuration,
                items: const [
                  AppDropdownItem(value: 4, label: "4 detik"),
                  AppDropdownItem(value: 10, label: "10 detik"),
                  AppDropdownItem(value: 15, label: "15 detik"),
                  AppDropdownItem(value: 20, label: "20 detik"),
                  AppDropdownItem(value: 30, label: "30 detik"),
                ],
                onChanged: (value) => setState(() => selectedDuration = value),
              ),
              AppButton(
                label: "Minute by Minute",
                onPressed: () => context.push("/measure"),
              ),
              AppButton(
                label: "Debug",
                onPressed: () => context.push("/debug"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
