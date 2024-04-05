import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_bloc.dart';
import 'package:rooster/screens/home.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';
import 'package:rooster/screens/user_verification_screen.dart';

import '../../blocs/user_verification_bloc/user_verification_state.dart';
import '../route_not_found_screen.dart';


class RoosterRouter {
  static GoRouter router = GoRouter(
      debugLogDiagnostics: false,
      redirect: (context, state) => appRouteRedirect(context, state),
      errorBuilder: (context, state) => RouteNotFoundScreen(routeError: state.error.toString()),
      routes: [
        GoRoute(
          path: RoosterScreenPath.homeScreen.route,
          name: RoosterScreenPath.homeScreen.name,
          pageBuilder: (context, state) => const MaterialPage(child: Home()),
        ),
        GoRoute(
          path: RoosterScreenPath.onboardingScreen.route,
          name: RoosterScreenPath.onboardingScreen.name,
          pageBuilder: (context, state) => MaterialPage(child: UserVerificationScreen()),
        ),
        GoRoute(
          path: RoosterScreenPath.velocityCrashesScreen.route,
          name: RoosterScreenPath.velocityCrashesScreen.name,
          pageBuilder: (context, state) => const MaterialPage(child: Home()),
        ),
        GoRoute(
          path: RoosterScreenPath.velocityCrashInfoScreen.route,
          name: RoosterScreenPath.velocityCrashInfoScreen.name,
          pageBuilder: (context, state) => const MaterialPage(child: Home()),
        ),
        GoRoute(
          path: RoosterScreenPath.routeErrorScreen.route,
          name: RoosterScreenPath.routeErrorScreen.name,
          pageBuilder: (context, state) => const MaterialPage(
              child: RouteNotFoundScreen(routeError: 'Route not found')
          ),
        ),
      ]);
}

Future<String?> appRouteRedirect(BuildContext context, GoRouterState state) async  {
  final userVerificationStatus = context.read<UserVerificationBloc>().state.status;
  final isRoutingToHome = state.matchedLocation == RoosterScreenPath.homeScreen.route;
  final isRoutingToOnBoarding = state.matchedLocation == RoosterScreenPath.onboardingScreen.route;

  if(userVerificationStatus == VerificationStatus.success && !isRoutingToHome) {
    return RoosterScreenPath.homeScreen.route;
  }

  if(userVerificationStatus == VerificationStatus.failure && !isRoutingToOnBoarding) {
    return RoosterScreenPath.onboardingScreen.route;
  }

  return null;
}