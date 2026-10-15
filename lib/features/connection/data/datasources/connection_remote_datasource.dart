import 'package:supabase_flutter/supabase_flutter.dart';

/// Calls the `connect_to_doctor` RPC and reads doctor rows from `profiles`.
class ConnectionRemoteDatasource {
  ConnectionRemoteDatasource(this._client);

  final SupabaseClient _client;

  /// Returns the connected doctor's id. Throws [PostgrestException] with
  /// code `P0002` on an invalid code.
  Future<String> connectToDoctor(String code) async {
    final result = await _client.rpc(
      'connect_to_doctor',
      params: {'p_code': code},
    );
    return result as String;
  }

  Future<Map<String, dynamic>> fetchProfile(String userId) {
    return _client.from('profiles').select().eq('id', userId).single();
  }
}
