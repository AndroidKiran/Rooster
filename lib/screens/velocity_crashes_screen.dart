import 'package:flutter/material.dart';

class VelocityCrashesScreen extends StatelessWidget {
  const VelocityCrashesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          centerTitle: true,
          title: _headerText(),
        ));
  }

  Widget _headerText() => Text(
        'Velocity Crashes',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.normal,
            fontFamily: 'Open Sans',
            fontSize: 32),
      );
}
