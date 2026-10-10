import 'package:flutter/material.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/features/measure/presentation/widgets/measure_countdown_view.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: MeasureCountdownView(secondsLeft: 2),
    );
  }
}
