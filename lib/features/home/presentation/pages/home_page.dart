import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';

/// Home tab: a summary of the last check plus the entry point into a new
/// one. The "last check" card has no data source yet (no history feature),
/// so it only ever shows the honest empty state for now.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(showLogo: true, label: 'NuroPulse'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengecekan terakhir',
              style: FontTheme.heading.copyWith(color: BaseColors.ink),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: BaseColors.surfaceRaised,
                border: Border.all(color: BaseColors.line),
                borderRadius: BorderRadius.circular(20), // radius-lg
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.monitor_heart_outlined,
                    size: 40,
                    color: BaseColors.inkMuted,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada riwayat pengecekan',
                    textAlign: TextAlign.center,
                    style: FontTheme.bodyLg.copyWith(color: BaseColors.ink),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mulai cek pertama Anda untuk melihat ringkasannya di sini.',
                    textAlign: TextAlign.center,
                    style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
                  ),
                ],
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Mulai Cek Tremor',
              icon: Icons.favorite_border,
              onPressed: () => context.push('/measure'),
            ),
          ],
        ),
      ),
    );
  }
}
