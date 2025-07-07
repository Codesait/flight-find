import 'package:flight_search/features/flight_search/presentation/pages/flight_detail_page.dart';
import 'package:flight_search/features/flight_search/presentation/pages/home.dart';
import 'package:flight_search/features/flight_search/presentation/pages/search_flight_results_page.dart';
import 'package:flight_search/features/flight_search/presentation/pages/search_flights.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import 'package:stakeny_mobile/common/src/screens.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final authNavKey = GlobalKey<NavigatorState>();

CustomTransitionPage<T> buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}

class AppRouterConfig {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    /**
     *! Will modify error page
     */
    errorBuilder:
        (context, state) =>
            const SizedBox(child: Scaffold(body: Center(child: Text('Error')))),
    routes: <RouteBase>[
      // /**
      //  ** Entry route
      //  */
      // GoRoute(
      //   parentNavigatorKey: rootNavigatorKey,
      //   path: '/',
      //   name: SplashScreen.splashPath,
      //   pageBuilder: (context, state) {
      //     return buildPageWithDefaultTransition(
      //       context: context,
      //       state: state,
      //       child: const SplashScreen(),
      //     );
      //   },
      // ),

      /**
       ** home screen 
       */
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/home',
        name: HomePage.route,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const HomePage(),
          );
        },
      ),

      /**
       ** search flight page 
       */
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/search',
        name: SearchFlights.route,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const SearchFlights(),
          );
        },
      ),

      /**
       ** flight result page 
       */
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/flight-results',
        name: SearchFlightResultsPage.route,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: SearchFlightResultsPage(
              flightResult: state.extra as Map<String, dynamic>?,
            ),
          );
        },
      ),

      /**
       ** flight details page 
       */
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/flight-details',
        name: FlightDetailPage.route,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const FlightDetailPage(),
          );
        },
      ),
    ],
    debugLogDiagnostics: true,
  );
}
