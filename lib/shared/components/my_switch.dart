import 'package:flutter/material.dart';
import 'package:todolist/shared/values/theme_values.dart';

class MySwitch extends StatelessWidget {
  final Color? activeColor;
  final bool value;
  final Function(bool)? onChanged;
  const MySwitch({
    super.key,
    required this.activeColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: activeColor,
      value: ThemeValues(context).watch.isDarkMode,
      onChanged: onChanged,
    );
  }
}
