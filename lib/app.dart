import 'package:flutter/material.dart';
import 'package:nuropulse/services/logger_service.dart';
import 'package:nuropulse/services/router_service.dart';

class App extends StatelessWidget {
  const App({super.key, required this.logger});

  final LoggerService logger;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NuroPulse',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
