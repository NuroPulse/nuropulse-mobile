import 'package:go_router/go_router.dart';
import 'package:nuropulse/features/home/presentation/pages/home_page.dart';
import 'package:nuropulse/features/measure/presentation/pages/measure_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/measure', builder: (context, state) => const MeasurePage()),
  ],
);
