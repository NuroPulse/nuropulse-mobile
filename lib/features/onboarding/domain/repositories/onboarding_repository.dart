/// Whether the user has opted out of seeing onboarding again.
abstract class OnboardingRepository {
  /// Read synchronously — the router needs this before the widget tree
  /// exists, to decide the app's initial route.
  bool hasCompleted();

  Future<void> markCompleted();
}
