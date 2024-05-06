enum RoosterScreenPath {
  homeScreen(route: '/home'),
  onboardingScreen(route: '/onboardingScreen'),
  allUsersScreen(route: '/allUsersScreen'),
  addNewUserScreen(route: '/addNewUserScreen'),
  allIssuesScreen(route: '/allIssuesScreen'),
  issueInfoScreen(route: '/issueInfoScreen/:issueId'),
  onCallPolicyScreen(route: '/onCallPolicyScreen'),
  routeErrorScreen(route: '/routeErrorScreen');

  const RoosterScreenPath({required this.route});

  final String route;
}
