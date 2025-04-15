import 'package:flutter/material.dart';

class MyFilledButton extends StatelessWidget {
  final WidgetStateProperty<Color?>? backgroundColor;
  final Widget? child;
  final Function()? onPressed;

  const MyFilledButton({
    super.key,
    this.backgroundColor,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(backgroundColor: backgroundColor),
      onPressed: onPressed,
      child: child,
    );
  }
}
