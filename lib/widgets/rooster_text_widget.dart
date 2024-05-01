import 'package:flutter/material.dart';

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
