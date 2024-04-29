enum RoosterScreenPath {
  homeScreen(route: '/home'),
  onboardingScreen(route: '/onboardingScreen'),
  allUsersScreen(route: '/allUsersScreen'),
  addNewUserScreen(route: '/addNewUserScreen'),
  velocityCrashesScreen(route: '/velocityCrashesScreen'),
  velocityCrashInfoScreen(route: '/velocityCrashInfoScreen'),
  onCallPolicyScreen(route: '/onCallPolicyScreen'),
  routeErrorScreen(route: '/routeErrorScreen');

  const RoosterScreenPath({required this.route});

  final String route;
}
