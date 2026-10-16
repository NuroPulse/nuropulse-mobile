import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/widgets/main_nav_bar.dart';
import 'package:nuropulse/features/history/presentation/cubit/history_cubit.dart';
import 'package:nuropulse/features/measure/domain/repositories/measurement_repository.dart';
import 'package:nuropulse/features/medication/domain/repositories/medication_repository.dart';
import 'package:nuropulse/features/medication/presentation/cubit/medication_cubit.dart';

/// Root of the bottom-nav shell: hosts each tab's own navigation stack via
/// [navigationShell] (go_router's `StatefulShellRoute`) and the bottom bar
/// that switches between them. Also provides the cubits shared between a
/// tab and whatever else reads them: [HistoryCubit] (home tab's "last
/// check" card + history tab) and [MedicationCubit] (Obat tab).
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              HistoryCubit(context.read<MeasurementRepository>()),
        ),
        BlocProvider(
          create: (context) =>
              MedicationCubit(context.read<MedicationRepository>()),
        ),
      ],
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
