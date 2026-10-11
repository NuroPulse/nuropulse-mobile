import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

/// Bottom navigation for the home shell's four top-level destinations.
/// Stateless: the shell route owns which tab is active and reacts to taps —
/// this widget never tracks navigation state itself.
class MainNavBar extends StatelessWidget {
  const MainNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: BaseColors.surfaceRaised,
        border: Border(top: BorderSide(color: BaseColors.line)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GNav(
            selectedIndex: selectedIndex,
            onTabChange: onTap,
            gap: 8,
            color: BaseColors.inkMuted,
            activeColor: BaseColors.onPrimary,
            tabBackgroundColor: BaseColors.primary,
            tabBorderRadius: 999, // radius-full
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            textStyle: FontTheme.caption.copyWith(
              color: BaseColors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
            tabs: const [
              GButton(
                backgroundColor: BaseColors.secondary500,
                icon: Icons.favorite_border,
                text: 'Cek Tremor',
              ),
              GButton(icon: Icons.medication_outlined, text: 'Obat'),
              GButton(
                backgroundColor: BaseColors.secondary500,
                icon: Icons.history,
                text: 'Riwayat',
              ),
              GButton(icon: Icons.person_outline, text: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }
}
