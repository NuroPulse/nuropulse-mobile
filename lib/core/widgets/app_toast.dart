import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

enum AppToastTone { info, success, warning, danger }

/// Toast content; use [showAppToast] rather than this directly.
class AppToast extends StatelessWidget {
  const AppToast({
    super.key,
    required this.message,
    this.tone = AppToastTone.info,
  });

  final String message;
  final AppToastTone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 12, // space-3
      children: [
        Icon(_iconFor(tone), color: _colorFor(tone), size: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: FontTheme.body.copyWith(
                  fontSize: 14,
                  color: BaseColors.surface,
                ),
              ),
              SizedBox(height: 3),
            ],
          ),
        ),
      ],
    );
  }

  static IconData _iconFor(AppToastTone tone) {
    return switch (tone) {
      AppToastTone.info => Icons.info_outline,
      AppToastTone.success => Icons.check_circle_outline,
      AppToastTone.warning => Icons.warning_amber_rounded,
      AppToastTone.danger => Icons.error_outline,
    };
  }

  static Color _colorFor(AppToastTone tone) {
    return switch (tone) {
      AppToastTone.info => BaseColors.primary200,
      AppToastTone.success => BaseColors.successSoft,
      AppToastTone.warning => BaseColors.warningSoft,
      AppToastTone.danger => BaseColors.dangerSoft,
    };
  }
}

/// Shows an [AppToast] via [ScaffoldMessenger], replacing any toast already
/// on screen so they never queue up behind each other.
void showAppToast(
  BuildContext context, {
  required String message,
  AppToastTone tone = AppToastTone.info,
  Duration duration = const Duration(seconds: 4),
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: AppToast(message: message, tone: tone),
        duration: duration,
        action: action,
      ),
    );
}
