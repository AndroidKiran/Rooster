import 'package:flutter/material.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class OnCallPolicyScreen extends StatelessWidget {
  const OnCallPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          centerTitle: true,
          title: RoosterTextWidget(
              text: 'OnCall Policies',
              textSize: 32,
              textColor: Colors.grey[800],
              maxLines: 1),
        ));
  }
}
