import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_bloc.dart';
import 'package:rooster/screens/add_new_user_screen.dart';
import 'package:rooster/screens/all_issues_screen.dart';
import 'package:rooster/screens/all_users_screen.dart';
import 'package:rooster/screens/employee_verification_screen.dart';
import 'package:rooster/screens/home_screen.dart';
import 'package:rooster/screens/issue_info_screen.dart';
import 'package:rooster/screens/on_call_policy_screen.dart';
import 'package:rooster/screens/route_not_found_screen.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';

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
          pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey, child: EmployeeVerificationScreen()),
        ),
        GoRoute(
          path: RoosterScreenPath.routeErrorScreen.route,
          name: RoosterScreenPath.routeErrorScreen.name,
          pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const RouteNotFoundScreen(routeError: 'Route not found')),
        ),
        GoRoute(
            path: RoosterScreenPath.allIssuesScreen.route,
            name: RoosterScreenPath.allIssuesScreen.name,
            pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey, child: const AllIssuesScreen())),
        GoRoute(
            path: RoosterScreenPath.issueInfoScreen.route,
            name: RoosterScreenPath.issueInfoScreen.name,
            pageBuilder: (context, state) {
              final String issueId = state.pathParameters['issueId'] ?? '';
              return MaterialPage(
                  key: state.pageKey, child: IssueInfoScreen(issueId: issueId));
            }),
        GoRoute(
            path: RoosterScreenPath.allUsersScreen.route,
            name: RoosterScreenPath.allUsersScreen.name,
            pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey, child: const AllUsersScreen())),
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
          userVerificationStatus == VerificationStatus.hasInvalidUser) ||
      userVerificationStatus == VerificationStatus.hasInvalidUser) {
    return RoosterScreenPath.onboardingScreen.route;
  }

  if (isRoutingToOnBoarding &&
      userVerificationStatus == VerificationStatus.hasValidUser) {
    return RoosterScreenPath.homeScreen.route;
  }

  return null;
}
