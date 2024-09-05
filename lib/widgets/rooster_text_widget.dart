import 'package:flutter/material.dart';

/// A custom StatelessWidget that displays text with customizable styling.
///
/// This widget provides a convenient way to create and customize text elements
/// in your Flutter application with consistent styling, including font size,
/// color, alignment, and overflow behavior.

class RoosterTextWidget extends StatelessWidget {
  final String text;
  final double textSize;
  final Color? textColor;
  final int? maxLines;
  final FontWeight? fontWeight;

  const RoosterTextWidget(
      {super.key,
      required this.text,
      required this.textSize,
      this.textColor,
      this.maxLines,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: textSize,
        color: textColor,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        fontFamily: 'Open Sans',
      ),
    );
  }
}
