import 'package:go_router/go_router.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';
import 'package:nuropulse/features/dev/presentation/pages/debug_page.dart';
import 'package:nuropulse/features/home/presentation/pages/home_page.dart';
import 'package:nuropulse/features/measure/presentation/pages/measure_detail_page.dart';
import 'package:nuropulse/features/measure/presentation/pages/measure_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/debug', builder: (context, state) => const DebugPage()),
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
  ],
);
