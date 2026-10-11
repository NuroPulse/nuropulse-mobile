import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';

/// Stand-in for a home-shell tab whose feature isn't built yet. Medication
/// is blocked until its data contract exists (CLAUDE.md section 13); history
/// and profile need features (`history/`, `auth/`) this repo doesn't have
/// yet either.
class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(showLogo: true, label: title),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: BaseColors.inkMuted),
              const SizedBox(height: 16),
              Text(
                'Segera hadir',
                textAlign: TextAlign.center,
                style: FontTheme.heading.copyWith(color: BaseColors.ink),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
