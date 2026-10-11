import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/onboarding/domain/repositories/onboarding_repository.dart';

/// State is just whether onboarding is marked complete. The slide index and
/// "don't show again" checkbox are pure UI state and stay local to the page.
class OnboardingCubit extends Cubit<bool> {
  OnboardingCubit(this._repository) : super(_repository.hasCompleted());

  final OnboardingRepository _repository;

  /// Called from the last slide. Onboarding only stops reappearing on
  /// future launches when the user opted out.
  Future<void> finish({required bool dontShowAgain}) async {
    if (!dontShowAgain) return;
    try {
      await _repository.markCompleted();
      emit(true);
    } on Failure {
      // Swallowed: worst case, onboarding simply reappears next launch —
      // an acceptable fallback for a non-critical local preference.
    }
  }
}
