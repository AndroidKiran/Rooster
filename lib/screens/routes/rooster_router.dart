import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_bloc.dart';
import 'package:rooster/screens/add_new_user_screen.dart';
import 'package:rooster/screens/all_users_screen.dart';
import 'package:rooster/screens/crashInfo_screen.dart';
import 'package:rooster/screens/crashes_screen.dart';
import 'package:rooster/screens/home_screen.dart';
import 'package:rooster/screens/on_call_policy_screen.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';
import 'package:rooster/screens/user_verification_screen.dart';

import '../../blocs/user_verification_bloc/user_verification_state.dart';
import '../route_not_found_screen.dart';

class RoosterRouter {
  static final RoosterRouter _singleton = RoosterRouter._();

  factory RoosterRouter() => _singleton;

  RoosterRouter._();

  GoRouter router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: RoosterScreenPath.homeScreen.route,
      redirect: (context, state) => appRouteRedirect(context, state),
      errorBuilder: (context, state) =>
          RouteNotFoundScreen(routeError: state.error.toString()),
      routes: [
        GoRoute(
          path: RoosterScreenPath.homeScreen.route,
          name: RoosterScreenPath.homeScreen.name,
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const HomeScreen()),
        ),
        GoRoute(
          path: RoosterScreenPath.onboardingScreen.route,
          name: RoosterScreenPath.onboardingScreen.name,
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: UserVerificationScreen()),
        ),
        GoRoute(
          path: RoosterScreenPath.routeErrorScreen.route,
          name: RoosterScreenPath.routeErrorScreen.name,
          pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const RouteNotFoundScreen(routeError: 'Route not found')),
        ),
        GoRoute(
          path: RoosterScreenPath.crashesScreen.route,
          name: RoosterScreenPath.crashesScreen.name,
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const CrashesScreen()),
        ),
        GoRoute(
          path: RoosterScreenPath.crashInfoScreen.route,
          name: RoosterScreenPath.crashInfoScreen.name,
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const CrashInfoScreen()),
        ),
        GoRoute(
          path: RoosterScreenPath.allUsersScreen.route,
          name: RoosterScreenPath.allUsersScreen.name,
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const AllUsersScreen()),
        ),
        GoRoute(
          path: RoosterScreenPath.onCallPolicyScreen.route,
          name: RoosterScreenPath.onCallPolicyScreen.name,
          pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey, child: const OnCallPolicyScreen()),
        ),
        GoRoute(
          path: RoosterScreenPath.addNewUserScreen.route,
          name: RoosterScreenPath.addNewUserScreen.name,
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const AddNewUserScreen()),
        ),
      ]);
}

Future<String?> appRouteRedirect(
    BuildContext context, GoRouterState state) async {
  final userVerificationStatus =
      context.read<UserVerificationBloc>().state.status;
  final isRoutingToHome =
      state.matchedLocation == RoosterScreenPath.homeScreen.route;
  final isRoutingToOnBoarding =
      state.matchedLocation == RoosterScreenPath.onboardingScreen.route;

  if ((isRoutingToHome &&
          userVerificationStatus == VerificationStatus.failure) ||
      userVerificationStatus == VerificationStatus.failure) {
    return RoosterScreenPath.onboardingScreen.route;
  }

  if (isRoutingToOnBoarding &&
      userVerificationStatus == VerificationStatus.success) {
    return RoosterScreenPath.homeScreen.route;
  }

  return null;
}
