import 'package:flutter/material.dart';

/// A custom StatelessWidget that displays text (alphabets) within a shaped container.
///
/// This widget allows you to create visually appealing UI elements with customizable
/// background color, text color, container shape, border width, and border color.
/// The font size of the text is dynamically adjusted based on the container's height.
class RoosterShapeIconTextWidget extends StatelessWidget {
  final String alphabets;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final BoxShape shape;
  final double borderWidth;
  final Color borderColor;

  const RoosterShapeIconTextWidget({
    super.key,
    required this.alphabets,
    required this.backgroundColor,
    required this.textColor,
    required this.width,
    required this.height,
    required this.shape,
    required this.borderWidth,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(width: borderWidth, color: borderColor),
        shape: shape,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Center(
          child: Text(
            alphabets,
            style: TextStyle(
              fontSize: height * 0.4,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
