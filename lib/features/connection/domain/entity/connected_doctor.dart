/// Minimal info about the doctor a patient connected to, read from the
/// doctor's own `profiles` row.
class ConnectedDoctor {
  const ConnectedDoctor({required this.id, required this.fullName});

  final String id;
  final String fullName;
}
