/// `wa.me` click-to-chat link for [phone]. WhatsApp needs the full
/// international number with no leading `0` or `+`, so a local-format
/// Indonesian number (`08...`) is normalized to `62...`. A number already
/// starting with `62` is left as is.
Uri whatsappUri(String phone) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  final international = digits.startsWith('0')
      ? '62${digits.substring(1)}'
      : digits;
  return Uri.https('wa.me', '/$international');
}
