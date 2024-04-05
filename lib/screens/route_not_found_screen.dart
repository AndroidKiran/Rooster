import 'package:flutter/material.dart';

class RouteNotFoundScreen extends StatelessWidget {
  final String? routeError;

  const RouteNotFoundScreen({super.key, required this.routeError});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(routeError ?? "Route not found!"),
      ),
    );
  }
}