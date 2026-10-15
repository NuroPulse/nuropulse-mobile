import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';
import 'package:nuropulse/features/auth/presentation/pages/login_page.dart';
import 'package:nuropulse/features/auth/presentation/pages/profile_gate_page.dart';
import 'package:nuropulse/features/auth/presentation/pages/register_page.dart';
import 'package:nuropulse/features/connection/presentation/pages/connect_doctor_page.dart';
import 'package:nuropulse/features/dev/presentation/pages/component_gallery_page.dart';
import 'package:nuropulse/features/dev/presentation/pages/debug_page.dart';
import 'package:nuropulse/features/history/presentation/pages/history_page.dart';
import 'package:nuropulse/features/home/presentation/pages/home_page.dart';
import 'package:nuropulse/features/home/presentation/pages/home_placeholder_page.dart';
import 'package:nuropulse/features/home/presentation/pages/home_shell_page.dart';
import 'package:nuropulse/features/measure/presentation/pages/measure_detail_page.dart';
import 'package:nuropulse/features/measure/presentation/pages/measure_page.dart';
import 'package:nuropulse/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:nuropulse/features/onboarding/presentation/pages/onboarding_page.dart';

/// Built once in `main.dart`, after Hive is open, so [onboardingRepository]
/// can be read synchronously to pick the initial route.
GoRouter createRouter({required OnboardingRepository onboardingRepository}) {
  return GoRouter(
    initialLocation: onboardingRepository.hasCompleted() ? '/' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
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
                builder: (context, state) => const ProfileGatePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/connect',
        builder: (context, state) => const ConnectDoctorPage(),
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
}
