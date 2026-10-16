import 'package:nuropulse/features/medication/domain/entity/medication_log_status.dart';

/// One row in `medication_logs`: a dose marked taken or skipped.
class MedicationLogEntry {
  const MedicationLogEntry({
    required this.id,
    required this.patientMedicationId,
    required this.scheduledAt,
    required this.status,
    required this.loggedAt,
    this.takenAt,
  });

  final String id;
  final String patientMedicationId;
  final DateTime scheduledAt;
  final MedicationLogStatus status;
  final DateTime loggedAt;
  final DateTime? takenAt;
}
