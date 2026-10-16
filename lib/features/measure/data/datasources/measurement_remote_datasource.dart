import 'package:supabase_flutter/supabase_flutter.dart';

/// finishRecording() awaits upload() before showing the result, so a slow
/// or absent connection must not stall that screen (CLAUDE.md section 11).
const _timeout = Duration(seconds: 8);

/// Uploads to `measurements` and claims anonymous ones after login.
class MeasurementRemoteDatasource {
  MeasurementRemoteDatasource(this._client);

  final SupabaseClient _client;

  String? get currentUserId => _client.auth.currentUser?.id;

  /// Upserts on `id` so retrying the same measurement after a failed
  /// attempt can never create a duplicate row (CLAUDE.md section 9 step 3).
  Future<void> upload(Map<String, dynamic> payload) {
    return _client.from('measurements').upsert(payload).timeout(_timeout);
  }

  /// Attaches measurements uploaded while signed out to the now signed-in
  /// account. The RPC only touches rows still owned by nobody, so calling
  /// this with ids already claimed is harmless.
  Future<void> claim(List<String> ids) {
    if (ids.isEmpty) return Future.value();
    return _client
        .rpc('claim_measurements', params: {'p_ids': ids})
        .timeout(_timeout);
  }
}
