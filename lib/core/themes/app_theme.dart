import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: BaseColors.primary,
      onPrimary: BaseColors.onPrimary,
      primaryContainer: BaseColors.primarySoft,
      onPrimaryContainer: BaseColors.primary900,
      secondary: BaseColors.secondary,
      onSecondary: BaseColors.onSecondary,
      secondaryContainer: BaseColors.secondarySoft,
      onSecondaryContainer: BaseColors.secondary900,
      error: BaseColors.danger,
      onError: BaseColors.onDanger,
      errorContainer: BaseColors.dangerSoft,
      onErrorContainer: BaseColors.danger,
      surface: BaseColors.surface,
      onSurface: BaseColors.ink,
      onSurfaceVariant: BaseColors.inkMuted,
      surfaceContainerLowest: BaseColors.surface,
      surfaceContainerLow: BaseColors.surface,
      surfaceContainer: BaseColors.surfaceRaised,
      surfaceContainerHigh: BaseColors.surfaceRaised,
      surfaceContainerHighest: BaseColors.surfaceRaised,
      surfaceDim: BaseColors.surfaceSunken,
      outline: BaseColors.lineStrong,
      outlineVariant: BaseColors.line,
      inverseSurface: BaseColors.ink,
      onInverseSurface: BaseColors.surface,
      inversePrimary: BaseColors.primary200,
      surfaceTint: BaseColors.primary,
    );

    final textTheme = const TextTheme(
      displayLarge: FontTheme.display,
      displayMedium: FontTheme.display,
      displaySmall: FontTheme.display,
      headlineLarge: FontTheme.title,
      headlineMedium: FontTheme.title,
      headlineSmall: FontTheme.title,
      titleLarge: FontTheme.heading,
      titleMedium: FontTheme.heading,
      titleSmall: FontTheme.label,
      bodyLarge: FontTheme.bodyLg,
      bodyMedium: FontTheme.body,
      bodySmall: FontTheme.caption,
      labelLarge: FontTheme.label,
      labelMedium: FontTheme.caption,
      labelSmall: FontTheme.caption,
    ).apply(bodyColor: BaseColors.ink, displayColor: BaseColors.ink);

    // radius-md (buttons, inputs) and radius-lg (cards, bottom sheets),
    // per the design system's radius scale.
    const radiusMd = BorderRadius.all(Radius.circular(12));
    const radiusLg = BorderRadius.all(Radius.circular(20));

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: FontTheme.fontFamily,
      scaffoldBackgroundColor: BaseColors.surface,
      dividerTheme: const DividerThemeData(
        color: BaseColors.line,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: BaseColors.surface,
        foregroundColor: BaseColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: FontTheme.heading.copyWith(color: BaseColors.ink),
      ),
      cardTheme: CardThemeData(
        color: BaseColors.surfaceRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: radiusLg,
          side: const BorderSide(color: BaseColors.line),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BaseColors.primary,
          foregroundColor: BaseColors.onPrimary,
          disabledBackgroundColor: BaseColors.surfaceSunken,
          disabledForegroundColor: BaseColors.inkMuted,
          minimumSize: const Size.fromHeight(56), // touch-min
          textStyle: FontTheme.label,
          shape: RoundedRectangleBorder(borderRadius: radiusMd),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BaseColors.primary,
          side: const BorderSide(color: BaseColors.lineStrong),
          minimumSize: const Size.fromHeight(56), // touch-min
          textStyle: FontTheme.label,
          shape: RoundedRectangleBorder(borderRadius: radiusMd),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BaseColors.primary,
          textStyle: FontTheme.label,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BaseColors.surfaceRaised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: FontTheme.body.copyWith(color: BaseColors.inkMuted),
        labelStyle: FontTheme.body.copyWith(color: BaseColors.inkMuted),
        errorStyle: FontTheme.caption.copyWith(color: BaseColors.danger),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: const BorderSide(color: BaseColors.lineStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: const BorderSide(color: BaseColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: const BorderSide(color: BaseColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: const BorderSide(color: BaseColors.danger, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: BaseColors.ink,
        contentTextStyle: FontTheme.body.copyWith(color: BaseColors.surface),
        actionTextColor: BaseColors.primary200,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: radiusMd),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: BaseColors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: radiusLg.topLeft),
        ),
      ),
    );
  }
}
