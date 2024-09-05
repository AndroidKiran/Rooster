import 'package:flutter/material.dart';

/// A custom StatelessWidget that displays a tag or label with customizable appearance.
///
/// This widget allows you to easily create tags with rounded corners,
/// different shapes, background colors, and text styling. It ensures that
/// the text within the tag is limited to a single line and truncated with
/// an ellipsis if it exceeds the available space.
class RoosterTagWidget extends StatelessWidget {
  final String text;
  final double borderRadius;
  final BoxShape shape;
  final Color backgroundColor;
  final Color textColor;

  const RoosterTagWidget({
    super.key,
    required this.text,
    required this.borderRadius,
    required this.shape,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        shape: shape,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            fontFamily: 'Open Sans',
          ),
        ),
      ),
    );
  }
}
