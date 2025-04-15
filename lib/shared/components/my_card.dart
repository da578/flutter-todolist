import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Color? color;
  final double? elevation;
  final Widget? child;
  const MyCard({
    super.key,
    required this.color,
    required this.elevation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(color: color, elevation: elevation, child: child);
  }
}
