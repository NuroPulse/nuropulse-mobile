import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper over `Supabase.instance.client.auth` (GoTrue), for session
/// and credential operations only. The `profiles` table lives behind
/// [ProfileRemoteDatasource] instead, since it's a plain Postgres table,
/// not part of the auth client.
class AuthRemoteDatasource {
  AuthRemoteDatasource(this._client);

  final SupabaseClient _client;

  /// `fullName` and `phoneNumber` go into `raw_user_meta_data`, read by the
  /// `handle_new_user` trigger to fill `profiles.full_name`/`phone`
  /// (the latter is `NOT NULL`, so this must always be sent).
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'phone': phoneNumber},
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
