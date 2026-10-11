import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';
import 'package:nuropulse/features/dev/presentation/pages/component_gallery_page.dart';
import 'package:nuropulse/features/dev/presentation/pages/debug_page.dart';
import 'package:nuropulse/features/home/presentation/pages/home_page.dart';
import 'package:nuropulse/features/home/presentation/pages/home_placeholder_page.dart';
import 'package:nuropulse/features/home/presentation/pages/home_shell_page.dart';
import 'package:nuropulse/features/history/presentation/pages/history_page.dart';
import 'package:nuropulse/features/measure/presentation/pages/measure_detail_page.dart';
import 'package:nuropulse/features/measure/presentation/pages/measure_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeShellPage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/medication',
              builder: (context, state) => const HomePlaceholderPage(
                icon: Icons.medication_outlined,
                title: 'Obat',
                message: 'Jadwal dan catatan obat akan hadir di sini.',
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const HomePlaceholderPage(
                icon: Icons.person_outline,
                title: 'Profil',
                message: 'Profil dan koneksi dokter akan hadir di sini.',
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/measure',
      builder: (context, state) => const MeasurePage(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) =>
              MeasureDetailPage(result: state.extra! as TremorResult),
        ),
      ],
    ),
    GoRoute(
      path: '/debug',
      builder: (context, state) => const DebugPage(),
      routes: [
        GoRoute(
          path: 'kitchen-sink',
          builder: (context, state) => const ComponentGalleryPage(),
        ),
      ],
    ),
  ],
);
