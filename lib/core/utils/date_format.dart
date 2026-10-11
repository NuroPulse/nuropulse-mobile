const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// `12 Okt 2026, 14:05`, local time (CLAUDE.md section 8: user-facing text
/// is Indonesian).
String formatDateTime(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString();
  final month = _months[local.month - 1];
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day $month ${local.year}, $hour:$minute';
}
