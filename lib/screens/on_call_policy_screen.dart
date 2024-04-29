import 'package:flutter/material.dart';

class OnCallPolicyScreen extends StatelessWidget {
  const OnCallPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          centerTitle: true,
          title: _headerText(),
        ));
  }

  Widget _headerText() => Text(
        'OnCall Policies',
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
