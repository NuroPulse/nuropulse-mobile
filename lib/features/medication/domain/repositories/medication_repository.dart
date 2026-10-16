import 'package:nuropulse/features/medication/domain/entity/medication_log_entry.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_log_status.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_schedule.dart';

/// Read a patient's prescribed schedule and log doses against it. Throws
/// [MedicationFailure] on failure. Schedules themselves are doctor-only to
/// create or edit (RLS enforces this), mobile never writes one.
abstract class MedicationRepository {
  /// Active schedules prescribed to the signed-in patient.
  Future<List<MedicationSchedule>> getSchedules();

  /// Logs a dose for the schedule at [scheduleId].
  Future<void> logDose({
    required String scheduleId,
    required DateTime scheduledAt,
    required MedicationLogStatus status,
  });

  /// Dose history, most recent first.
  Future<List<MedicationLogEntry>> getLogs();
}
