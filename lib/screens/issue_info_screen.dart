import 'package:flutter/material.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class IssueInfoScreen extends StatelessWidget {
  const IssueInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          centerTitle: true,
          title: RoosterTextWidget(
              text: 'Crash Info',
              textSize: 32,
              textColor: Colors.grey[800],
              maxLines: 1),
        ));
  }
}
