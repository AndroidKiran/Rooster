import 'package:flutter/material.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

/// A screen that is displayed when the user navigates to a route that
/// doesn't exist in the application.
///
/// This screen shows a simple error message indicating that the requested
/// route was not found. It can also display a more specific error message
class RouteNotFoundScreen extends StatelessWidget {
  final String? routeError;

  const RouteNotFoundScreen({super.key, required this.routeError});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RoosterTextWidget(
          text: 'Route Error',
          textSize: 32,
          textColor: Colors.grey[800],
          maxLines: 1,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Center(
        child: RoosterTextWidget(
            text: routeError ?? "Route not found!",
            textSize: 20,
            textColor: Colors.grey[800]),
      ),
    );
  }
}
