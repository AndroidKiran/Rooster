enum RoosterScreenPath {
  homeScreen(route: '/home'),
  onboardingScreen(route: '/onboardingScreen'),
  allUsersScreen(route: '/allUsersScreen'),
  addNewUserScreen(route: '/addNewUserScreen'),
  crashesScreen(route: '/crashesScreen'),
  crashInfoScreen(route: '/crashInfoScreen'),
  onCallPolicyScreen(route: '/onCallPolicyScreen'),
  routeErrorScreen(route: '/routeErrorScreen');

  const RoosterScreenPath({required this.route});

  final String route;
}
