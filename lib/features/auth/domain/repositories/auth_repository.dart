import 'package:nuropulse/features/auth/domain/entity/profile.dart';

/// Register, login, logout, and session state. Throws [AuthFailure] on
/// failure, never a bare Supabase exception.
abstract class AuthRepository {
  /// Emits the signed-in [Profile], or `null` when signed out. Fires again
  /// on sign-in, sign-out, and token refresh.
  Stream<Profile?> get profileChanges;

  /// Returns `null` instead of a [Profile] when the project requires email
  /// confirmation: the account was created but there is no session yet
  /// until the user confirms. Signs out and throws [AuthFailure] if the
  /// resulting account is somehow not a `patient` role.
  Future<Profile?> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  });

  /// Signs out and throws [AuthFailure] if the account's role is not
  /// `patient`. The app never lets a doctor account stay signed in here.
  Future<Profile> login({required String email, required String password});

  Future<void> logout();

  /// Re-fetches the signed-in user's profile. [profileChanges] only reacts
  /// to auth state (sign in/out/refresh), not to a row update like
  /// connecting to a doctor, so callers refresh explicitly after one.
  Future<Profile> refreshProfile();
}
