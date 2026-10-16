/// Mirrors `medication_logs.status`. No enum constraint in the database
/// (it's free text with a default of `'taken'`), but mobile only ever
/// writes one of these two.
enum MedicationLogStatus { taken, skipped }
