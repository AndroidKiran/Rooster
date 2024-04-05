enum RoosterScreenPath {
  homeScreen(route : '/'),
  onboardingScreen(route : '/onboardingScreen'),
  velocityCrashesScreen(route: '/velocityCrashesScreen'),
  velocityCrashInfoScreen(route: '/velocityCrashInfoScreen'),
  routeErrorScreen(route: '/routeErrorScreen');

  const RoosterScreenPath({required this.route});
  final String route;
}