import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/widgets/main_nav_bar.dart';

/// Root of the bottom-nav shell: hosts each tab's own navigation stack via
/// [navigationShell] (go_router's `StatefulShellRoute`) and the bottom bar
/// that switches between them.
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: MainNavBar(
        selectedIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
