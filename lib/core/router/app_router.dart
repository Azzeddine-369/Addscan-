import 'package:go_router/go_router.dart';
import '../../presentation/screens/compare/compare_screen.dart';
import '../../presentation/screens/details/additive_details_screen.dart';
import '../../presentation/screens/main_scaffold.dart';
import '../../presentation/screens/report/report_screen.dart';
import '../../presentation/screens/scanner/barcode_scanner_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScaffold(initialIndex: 0),
    ),
    GoRoute(
      path: '/saved',
      builder: (context, state) => const MainScaffold(initialIndex: 1),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const MainScaffold(initialIndex: 2),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const MainScaffold(initialIndex: 3),
    ),
    GoRoute(
      path: '/details/:code',
      builder: (context, state) {
        final code = state.pathParameters['code'] ?? 'E330';
        return AdditiveDetailsScreen(code: code);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/compare',
      builder: (context, state) {
        final code = state.uri.queryParameters['code'];
        return CompareScreen(initialCode: code);
      },
    ),
    GoRoute(
      path: '/report',
      builder: (context, state) {
        final code = state.uri.queryParameters['code'];
        return ReportScreen(code: code);
      },
    ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const BarcodeScannerScreen(),
    ),
  ],
);
