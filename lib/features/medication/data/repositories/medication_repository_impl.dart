import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/medication/data/datasources/medication_remote_datasource.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_log_entry.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_log_status.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_schedule.dart';
import 'package:nuropulse/features/medication/domain/repositories/medication_repository.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  MedicationRepositoryImpl(this._datasource);

  final MedicationRemoteDatasource _datasource;

  @override
  Future<List<MedicationSchedule>> getSchedules() async {
    try {
      final rows = await _datasource.fetchSchedules();
      return [for (final row in rows) _scheduleFromJson(row)];
    } catch (error, stackTrace) {
      if (error is Failure) rethrow;
      Error.throwWithStackTrace(
        MedicationFailure('Failed to load schedules: $error'),
        stackTrace,
      );
    }
  }

  @override
  Future<void> logDose({
    required String scheduleId,
    required DateTime scheduledAt,
    required MedicationLogStatus status,
  }) async {
    try {
      await _datasource.upsertLog(
        scheduleId: scheduleId,
        scheduledAt: scheduledAt,
        status: status.name,
      );
    } catch (error, stackTrace) {
      if (error is Failure) rethrow;
      Error.throwWithStackTrace(
        MedicationFailure('Failed to log dose: $error'),
        stackTrace,
      );
    }
  }

  @override
  Future<List<MedicationLogEntry>> getLogs() async {
    try {
      final rows = await _datasource.fetchLogs();
      return [for (final row in rows) _logFromJson(row)];
    } catch (error, stackTrace) {
      if (error is Failure) rethrow;
      Error.throwWithStackTrace(
        MedicationFailure('Failed to load logs: $error'),
        stackTrace,
      );
    }
  }

  MedicationSchedule _scheduleFromJson(Map<String, dynamic> json) {
    final medicine = json['medicines'] as Map<String, dynamic>?;
    final rawTimes = (json['times'] as List?) ?? const [];
    return MedicationSchedule(
      id: json['id'] as String,
      medicineName: (medicine?['name'] as String?) ?? 'Obat',
      dose: json['dose'] as String,
      scheduleTimes: [for (final time in rawTimes) time as String],
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isActive: json['is_active'] as bool,
      instructions: json['instructions'] as String?,
    );
  }

  MedicationLogEntry _logFromJson(Map<String, dynamic> json) {
    return MedicationLogEntry(
      id: json['id'] as String,
      scheduleId: json['schedule_id'] as String?,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      status: json['status'] == 'taken'
          ? MedicationLogStatus.taken
          : MedicationLogStatus.skipped,
      loggedAt: DateTime.parse(json['logged_at'] as String),
      takenAt: json['taken_at'] == null
          ? null
          : DateTime.parse(json['taken_at'] as String),
    );
  }
}
