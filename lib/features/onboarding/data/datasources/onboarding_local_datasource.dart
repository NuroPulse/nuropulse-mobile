import 'package:nuropulse/services/storage/hive_service.dart';

/// Hive access for the one-time onboarding flag, stored in the shared
/// `settings` box (CLAUDE.md section 9).
class OnboardingLocalDatasource {
  OnboardingLocalDatasource(this._hive);

  final HiveService _hive;

  static const _key = 'onboarding';

  bool readCompleted() {
    final value = _hive.settings.get(_key);
    return value?['completed'] as bool? ?? false;
  }

  Future<void> writeCompleted() {
    return _hive.settings.put(_key, {'completed': true});
  }
}
