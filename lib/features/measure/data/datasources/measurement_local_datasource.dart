import 'package:nuropulse/services/storage/hive_service.dart';

/// Hive access for saved measurements. `uploaded` is local bookkeeping, kept
/// alongside the contract-shaped payload rather than inside it (CLAUDE.md
/// section 9).
class MeasurementLocalDatasource {
  MeasurementLocalDatasource(this._hive);

  final HiveService _hive;

  Future<void> save(
    String id,
    Map<String, dynamic> measurementJson, {
    required bool uploaded,
  }) {
    return _hive.measurements.put(id, {
      'uploaded': uploaded,
      'measurement': measurementJson,
    });
  }

  /// Hive returns nested maps as `Map<dynamic, dynamic>` after a reopen, so
  /// the whole tree is converted back to `Map<String, dynamic>` here.
  Map<String, dynamic>? read(String id) {
    final value = _hive.measurements.get(id);
    return value == null ? null : _toJsonMap(value);
  }

  static Map<String, dynamic> _toJsonMap(Map<dynamic, dynamic> map) {
    return {
      for (final entry in map.entries)
        entry.key as String: _toJsonValue(entry.value),
    };
  }

  static Object? _toJsonValue(Object? value) {
    return switch (value) {
      Map() => _toJsonMap(value),
      List() => [for (final item in value) _toJsonValue(item)],
      _ => value,
    };
  }
}
