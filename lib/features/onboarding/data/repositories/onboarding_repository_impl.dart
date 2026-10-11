import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:nuropulse/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._local);

  final OnboardingLocalDatasource _local;

  @override
  bool hasCompleted() {
    // Called before the widget tree exists (router construction in
    // main.dart) — a corrupt entry must fall back to showing onboarding
    // again, never crash app startup.
    try {
      return _local.readCompleted();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> markCompleted() async {
    try {
      await _local.writeCompleted();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageFailure('Failed to save onboarding flag: $error'),
        stackTrace,
      );
    }
  }
}
