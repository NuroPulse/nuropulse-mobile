import 'package:nuropulse/features/medication/domain/entity/medication_log_entry.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_log_status.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_schedule.dart';

/// Read a patient's prescribed schedule and log doses against it. Throws
/// [MedicationFailure] on failure. Schedules are meant to be doctor-only
/// to create or edit, but `medication_schedules`'s INSERT/UPDATE policies
/// currently allow any authenticated user, not just doctors. This app
/// never writes a schedule regardless; that's a product choice here, not
/// one RLS actually enforces.
abstract class MedicationRepository {
  /// Active schedules prescribed to the signed-in patient.
  Future<List<MedicationSchedule>> getSchedules();

  /// Sets the status for the schedule at [scheduleId]. `medication_logs`
  /// only ever holds one row per schedule (`schedule_id` is `UNIQUE`), so
  /// this replaces whatever was logged for it before, it does not add a
  /// new history entry.
  Future<void> logDose({
    required String scheduleId,
    required DateTime scheduledAt,
    required MedicationLogStatus status,
  });

  /// Current logged status per schedule, most recently updated first. Not
  /// a per-dose history: at most one entry per schedule can ever exist.
  Future<List<MedicationLogEntry>> getLogs();
}
