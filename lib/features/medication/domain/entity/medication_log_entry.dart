import 'package:nuropulse/features/medication/domain/entity/medication_log_status.dart';

/// One row in `medication_logs`: a dose marked taken or skipped.
class MedicationLogEntry {
  const MedicationLogEntry({
    required this.id,
    required this.scheduledAt,
    required this.status,
    required this.loggedAt,
    this.scheduleId,
    this.takenAt,
  });

  final String id;

  /// Null if the schedule it was logged against was later deleted
  /// (`ON DELETE SET NULL`).
  final String? scheduleId;

  final DateTime scheduledAt;
  final MedicationLogStatus status;
  final DateTime loggedAt;
  final DateTime? takenAt;
}
