import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontsize;
  final FontWeight? fontwight;
  final Color? color;
  final Alignment? alignment;

  final int? maxLines;
  final double? height;

  CustomText(
      {this.text,
      this.fontsize,
      this.fontwight,
      this.color,
      this.alignment,
      this.maxLines,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        fontSize: fontsize,
        fontWeight: fontwight,
        color: color,
        height: height,
      ),
      maxLines: maxLines,
    );
  }
}
