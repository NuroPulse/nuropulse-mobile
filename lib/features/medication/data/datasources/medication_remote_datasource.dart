import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads `medication_schedules` (joined with `medicines` for the name) and
/// `medication_logs`.
class MedicationRemoteDatasource {
  MedicationRemoteDatasource(this._client);

  final SupabaseClient _client;

  /// `medication_schedules`'s SELECT policy is `TO PUBLIC USING (true)`,
  /// not scoped to the signed-in patient at all, unlike every other table
  /// this app reads. Filtered explicitly here rather than trusting RLS.
  Future<List<Map<String, dynamic>>> fetchSchedules() async {
    final patientId = _requireUserId();
    final result = await _client
        .from('medication_schedules')
        .select('*, medicines(name, common_dosage)')
        .eq('patient_id', patientId)
        .eq('is_active', true)
        .order('created_at');
    return List<Map<String, dynamic>>.from(result as List);
  }

  /// `medication_logs.schedule_id` is `UNIQUE`, so at most one log row can
  /// ever exist per schedule: this is a "current status," not a per-dose
  /// history table. Upserts on `schedule_id` so logging again replaces the
  /// previous entry instead of failing. Every field is always included
  /// (never conditionally omitted), since an upsert only overwrites the
  /// columns given, an omitted `taken_at` would leave a stale value behind
  /// after switching from taken to skipped.
  Future<void> upsertLog({
    required String scheduleId,
    required DateTime scheduledAt,
    required String status,
  }) {
    final now = DateTime.now().toUtc().toIso8601String();
    return _client.from('medication_logs').upsert({
      'schedule_id': scheduleId,
      'scheduled_at': scheduledAt.toUtc().toIso8601String(),
      'status': status,
      'taken_at': status == 'taken' ? now : null,
      'logged_at': now,
      // No trigger sets this one (unlike measurements.uploaded_at), so
      // mobile has to.
      'uploaded_at': now,
    }, onConflict: 'schedule_id');
  }

  Future<List<Map<String, dynamic>>> fetchLogs() async {
    final result = await _client
        .from('medication_logs')
        .select()
        .order('scheduled_at', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(result as List);
  }

  String _requireUserId() {
    final id = _client.auth.currentUser?.id;
    if (id == null) {
      throw StateError('fetchSchedules() called while signed out');
    }
    return id;
  }
}
