import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper over `Supabase.instance.client.auth` (GoTrue), for session
/// and credential operations only. The `profiles` table lives behind
/// [ProfileRemoteDatasource] instead, since it's a plain Postgres table,
/// not part of the auth client.
class AuthRemoteDatasource {
  AuthRemoteDatasource(this._client);

  final SupabaseClient _client;

  /// `fullName` goes into `raw_user_meta_data`, the only signup field the
  /// client can set. `role` lives in `raw_app_meta_data`, which signUp()
  /// has no parameter for at all, so the mobile app structurally cannot set
  /// it.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() => _client.auth.signOut();

  /// Current session's user id, or null if signed out.
  String? get currentUserId => _client.auth.currentUser?.id;

  Stream<Session?> authStateChanges() {
    return _client.auth.onAuthStateChange.map((state) => state.session);
  }
}
