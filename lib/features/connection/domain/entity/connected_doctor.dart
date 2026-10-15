/// Minimal info about the doctor a patient connected to, read from the
/// doctor's own `profiles` row. [phone] is a WhatsApp number (every
/// `profiles.phone` in this app is).
class ConnectedDoctor {
  const ConnectedDoctor({
    required this.id,
    required this.fullName,
    required this.phone,
  });

  final String id;
  final String fullName;
  final String phone;
}
