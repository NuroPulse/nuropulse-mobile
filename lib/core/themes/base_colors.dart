import 'package:flutter/material.dart';

abstract final class BaseColors {
  /* ----------------------------- Primary Shades ----------------------------- */
  static const Color primary50 = Color(0xFFF1F5FE);
  static const Color primary100 = Color(0xFFE1E9FE);
  static const Color primary200 = Color(0xFFC3D4FD);
  static const Color primary300 = Color(0xFF9CB5F8);
  static const Color primary400 = Color(0xFF6E8FF1);
  static const Color primary500 = Color(0xFF4A6CE0);
  static const Color primary600 = Color(0xFF3653C5);
  static const Color primary700 = Color(0xFF2941A3);
  static const Color primary800 = Color(0xFF1E327D);
  static const Color primary900 = Color(0xFF142359);

  /* ---------------------------- Secondary Shades ---------------------------- */
  static const Color secondary50 = Color(0xFFEBFCEF);
  static const Color secondary100 = Color(0xFFD5F7DD);
  static const Color secondary200 = Color(0xFFAEECBE);
  static const Color secondary300 = Color(0x5B7FDC9A);
  static const Color secondary400 = Color(0xFF50C277);
  static const Color secondary500 = Color(0xFF29A259);
  static const Color secondary600 = Color(0xFF158445);
  static const Color secondary700 = Color(0xFF0E6936);
  static const Color secondary800 = Color(0xFF104F29);
  static const Color secondary900 = Color(0xFF0A371B);

  /* -------------------------------- Surfaces -------------------------------- */
  static const Color surface = Color(0xFFF6F7FB);
  static const Color surfaceRaised = Color(0xFFFFFFFF);
  static const Color surfaceSunken = Color(0xFFECEEF5);

  /* ---------------------------------- Lines --------------------------------- */
  static const Color line = Color(0xFFD3D7E3);
  static const Color lineStrong = Color(0xFF6C7489);

  /* ----------------------------------- Ink ---------------------------------- */
  static const Color ink = Color(0xFF141A2E);
  static const Color inkMuted = Color(0xFF4A5168);

  /* ----------------------------- Semantic Brand ----------------------------- */
  static const Color primary = primary700;
  static const Color primaryPressed = primary800;
  static const Color primarySoft = primary50;
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color secondary = secondary700;
  static const Color secondaryPressed = secondary800;
  static const Color secondarySoft = secondary100;
  static const Color onSecondary = Color(0xFFFFFFFF);

  /* --------------------------------- Status --------------------------------- */
  static const Color success = Color(0xFF0A6380);
  static const Color successSoft = Color(0xFFE0F1F7);
  static const Color warning = Color(0xFF735C00);
  static const Color warningSoft = Color(0xFFFFF5C2);
  static const Color danger = Color(0xFFB3261E);
  static const Color dangerSoft = Color(0xFFFCE6E4);
  static const Color onDanger = Color(0xFFFFFFFF);

  /* ------------------------------ Focus & Link ------------------------------ */
  static const Color focus = primary900;
  static const Color link = primary;

  /* ---------------------------------- Chart ---------------------------------- */
  static const Color chart1 = primary600;
  static const Color chart2 = secondary600;
}
