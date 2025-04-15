import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class ThemeValues {
  final BuildContext context;
  const ThemeValues(this.context);
  ThemeProvider get watch => context.watch<ThemeProvider>();
  ThemeProvider get read => context.read<ThemeProvider>();
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
}
