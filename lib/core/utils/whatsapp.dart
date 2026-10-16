/// `wa.me` click-to-chat link for [phone]. WhatsApp needs the full
/// international number with no leading `0`, `00`, or `+`. There's no
/// backend constraint on what format `profiles.phone` is actually stored
/// in, so this normalizes whatever shape shows up: `08...` (local),
/// `62...` (already international), `+62...` or `0062...` (either prefix
/// stripped before the digits check, since the regex below already drops
/// non-digit characters like `+`).
Uri whatsappUri(String phone) {
  var digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('00')) {
    digits = digits.substring(2);
  } else if (digits.startsWith('0')) {
    digits = '62${digits.substring(1)}';
  }
  return Uri.https('wa.me', '/$digits');
}
