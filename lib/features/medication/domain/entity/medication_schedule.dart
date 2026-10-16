/// One prescribed medication, from `medication_schedules` joined with
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
    this.instructions,
  });

  final String id;
  final String medicineName;
  final String dose;

  /// One per dose per day, whatever text format the doctor entered.
  final List<String> scheduleTimes;

  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? instructions;
}
