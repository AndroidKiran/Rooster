enum RoosterScreenPath {
  homeScreen(route: '/home'),
  onboardingScreen(route: '/onboardingScreen'),
  allUsersScreen(route: '/allUsersScreen'),
  allIssuesScreen(route: '/allIssuesScreen'),
  issueInfoScreen(route: '/issueInfoScreen/:issueId'),
  userInfoScreen(route: '/userInfoScreen/:userId'),
  addNewUserScreen(route: '/addNewUserScreen'),
  onCallPolicyScreen(route: '/onCallPolicyScreen'),
  routeErrorScreen(route: '/routeErrorScreen');

  const RoosterScreenPath({required this.route});

  final String route;
}
