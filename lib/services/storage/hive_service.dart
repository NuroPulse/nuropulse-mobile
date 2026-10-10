import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:nuropulse/core/errors/failure.dart';

/// Owns the app's Hive boxes. Stores JSON maps only — no TypeAdapters
/// (CLAUDE.md section 9).
class HiveService {
  static const measurementsBoxName = 'measurements';
  static const settingsBoxName = 'settings';

  Box<Map>? _measurements;
  Box<Map>? _settings;

  /// Call once from main.dart before runApp.
  Future<void> init() async {
    await Hive.initFlutter();
    await openBoxes();
  }

  /// Opens the boxes without initializing the Hive directory. Tests call
  /// this after `Hive.init(path)` with a temporary directory.
  Future<void> openBoxes() async {
    try {
      _measurements = await Hive.openBox<Map>(measurementsBoxName);
      _settings = await Hive.openBox<Map>(settingsBoxName);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageFailure('Failed to open Hive boxes: $error'),
        stackTrace,
      );
    }
  }

  Box<Map> get measurements => _requireOpen(_measurements, measurementsBoxName);

  Box<Map> get settings => _requireOpen(_settings, settingsBoxName);

  Box<Map> _requireOpen(Box<Map>? box, String name) {
    if (box == null) {
      throw StateError('Hive box "$name" is not open. Call init() first.');
    }
    return box;
  }
}
