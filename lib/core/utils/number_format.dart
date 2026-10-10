/// Fixed-point with an Indonesian decimal comma, e.g. `formatNumber(3.57, 2)`
/// -> `'3,57'` (CLAUDE.md section 8: user-facing numbers are Indonesian).
String formatNumber(double value, int digits) {
  return value.toStringAsFixed(digits).replaceAll('.', ',');
}
