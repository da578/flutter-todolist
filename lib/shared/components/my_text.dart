import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String data;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isLineThrough;
  final Color? decorationColor;

  const MyText(
    this.data, {
    super.key,
    this.color,
    this.size,
    this.weight,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.isLineThrough = false,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        decoration: isLineThrough ? TextDecoration.lineThrough : null,
        decorationColor: decorationColor,
        color: color,
        fontSize: size,
        fontWeight: weight,
        overflow: overflow,
      ),

      maxLines: maxLines,
    );
  }
}
