import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogo;
  final String? label;

  const MainAppBar({super.key, this.showLogo = false, this.label});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 72,
      elevation: 3.0,
      shadowColor: BaseColors.ink,
      backgroundColor: BaseColors.primary,
      centerTitle: false,
      leading: context.canPop()
          ? IconButton(
              onPressed: () {
                context.pop();
              },
              icon: SvgPicture.asset(
                "assets/icons/move-left-icon.svg",
                colorFilter: ColorFilter.mode(
                  BaseColors.onPrimary,
                  BlendMode.srcIn,
                ),
              ),
            )
          : null,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 6,
        children: [
          if (showLogo)
            SvgPicture.asset(
              "assets/icons/nuropulse-logoalt.svg",
              width: 40,
              colorFilter: ColorFilter.mode(
                BaseColors.onPrimary,
                BlendMode.srcIn,
              ),
            ),
          if (label != null)
            Text(
              label!,
              style: FontTheme.heading.copyWith(color: BaseColors.onPrimary),
            ),
        ],
      ),
    );
  }
}
