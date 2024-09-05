/// An enum that represents the different screens or routes within the
/// Flutter application.
///
/// Each enum value corresponds to a specific screen and its associated
/// route path. This provides a structured way to define and manage routes
/// within the application.
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
