import 'package:flutter/material.dart';
import 'package:nuropulse/app.dart';
import 'package:nuropulse/services/logger_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = LoggerService();

  runApp(App(logger: logger));
}
