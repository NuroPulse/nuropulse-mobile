import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads `patient_medications` (joined with `medicines` for the name) and
/// `medication_logs`. RLS already scopes every query to the signed-in
/// patient, so nothing here filters by patient id explicitly.
class MedicationRemoteDatasource {
  MedicationRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<List<Map<String, dynamic>>> fetchSchedules() async {
    final result = await _client
        .from('patient_medications')
        .select('*, medicines(name, common_dosage)')
        .eq('is_active', true)
        .order('created_at');
    return List<Map<String, dynamic>>.from(result as List);
  }

  Future<void> insertLog({
    required String patientMedicationId,
    required DateTime scheduledAt,
    required String status,
  }) {
    final now = DateTime.now().toUtc().toIso8601String();
    return _client.from('medication_logs').insert({
      'patient_medication_id': patientMedicationId,
      'scheduled_at': scheduledAt.toUtc().toIso8601String(),
      'status': status,
      if (status == 'taken') 'taken_at': now,
      'logged_at': now,
      // No trigger sets this one (unlike measurements.uploaded_at), so
      // mobile has to.
      'uploaded_at': now,
    });
  }

  Future<List<Map<String, dynamic>>> fetchLogs() async {
    final result = await _client
        .from('medication_logs')
        .select()
        .order('scheduled_at', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(result as List);
  }
}
