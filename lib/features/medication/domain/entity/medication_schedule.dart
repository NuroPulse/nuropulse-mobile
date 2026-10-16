/// One prescribed medication, from `patient_medications` joined with
/// `medicines` for the name. Mobile only reads this: schedules are created
/// by a doctor from the dashboard.
class MedicationSchedule {
  const MedicationSchedule({
    required this.id,
    required this.medicineName,
    required this.dose,
    required this.scheduleTimes,
    required this.startDate,
    required this.isActive,
    this.endDate,
    this.notes,
  });

  final String id;
  final String medicineName;
  final String dose;

  /// "HH:mm", one per dose per day.
  final List<String> scheduleTimes;

  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? notes;
}
