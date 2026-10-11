import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/widgets/main_nav_bar.dart';
import 'package:nuropulse/features/history/presentation/cubit/history_cubit.dart';
import 'package:nuropulse/features/measure/domain/repositories/measurement_repository.dart';

/// Root of the bottom-nav shell: hosts each tab's own navigation stack via
/// [navigationShell] (go_router's `StatefulShellRoute`) and the bottom bar
/// that switches between them. Also provides the one [HistoryCubit] shared
/// by the home tab's "last check" card and the history tab's list, so both
/// read the same data and a refresh in one place shows up in the other.
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(context.read<MeasurementRepository>()),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: MainNavBar(
          selectedIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
        ),
      ),
    );
  }
}
