import 'package:flutter/material.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class AddNewUserScreen extends StatelessWidget {
  const AddNewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          centerTitle: true,
          title: RoosterTextWidget(
              text: 'New User',
              textSize: 32,
              textColor: Colors.grey[800],
              maxLines: null),
        ));
  }
}
