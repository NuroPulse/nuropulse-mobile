import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads the `profiles` table. The mobile app never inserts into it, a
/// database trigger creates the row on signup.
class ProfileRemoteDatasource {
  ProfileRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>> fetch(String userId) {
    return _client.from('profiles').select().eq('id', userId).single();
  }
}
