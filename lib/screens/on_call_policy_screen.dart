import 'package:flutter/material.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

/// A screen that is intended to display information about on-call policies.
///
/// Currently, this screen only sets up a basic scaffold with an app bar and
/// a deep purple background. It lacks any content or functionality related to
/// displaying actual on-call policies.
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
            maxLines: 1,
            fontWeight: FontWeight.w700,
          ),
        ));
  }
}
