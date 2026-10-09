import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

enum AppAlertTone { info, success, warning, danger }

/// Body text always stays [BaseColors.ink] regardless of [tone], for
/// contrast on the soft background; only the icon and border carry it.
class AppAlert extends StatelessWidget {
  const AppAlert({
    super.key,
    required this.message,
    this.title,
    this.tone = AppAlertTone.info,
    this.action,
  });

  final String message;
  final String? title;
  final AppAlertTone tone;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(tone);

    final content = Container(
      padding: const EdgeInsets.all(16), // space-4
      decoration: BoxDecoration(
        color: style.background,
        border: Border.all(color: style.accent, width: 2),
        borderRadius: BorderRadius.circular(12), // radius-md
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(style.icon, color: style.accent, size: 24),
          ),
          const SizedBox(width: 12), // space-3
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      fontFamily: FontTheme.fontFamily,
                      fontSize: 18,
                      height: 26 / 18,
                      fontWeight: FontWeight.w700,
                      color: BaseColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4), // space-1
                ],
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: FontTheme.fontFamily,
                    fontSize: 16,
                    height: 24 / 16,
                    color: BaseColors.ink,
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(height: 8), // space-2
                  action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );

    final announceImmediately =
        tone == AppAlertTone.warning || tone == AppAlertTone.danger;
    return Semantics(
      container: true,
      liveRegion: announceImmediately,
      child: content,
    );
  }

  static ({Color background, Color accent, IconData icon}) _styleFor(
    AppAlertTone tone,
  ) {
    return switch (tone) {
      AppAlertTone.info => (
        background: BaseColors.primarySoft,
        accent: BaseColors.primary,
        icon: Icons.info_outline,
      ),
      AppAlertTone.success => (
        background: BaseColors.successSoft,
        accent: BaseColors.success,
        icon: Icons.check_circle_outline,
      ),
      AppAlertTone.warning => (
        background: BaseColors.warningSoft,
        accent: BaseColors.warning,
        icon: Icons.warning_amber_rounded,
      ),
      AppAlertTone.danger => (
        background: BaseColors.dangerSoft,
        accent: BaseColors.danger,
        icon: Icons.error_outline,
      ),
    };
  }
}
