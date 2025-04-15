import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todolist/shared/components/my_card.dart';
import 'package:todolist/shared/components/my_switch.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';

class SettingsTheme extends StatefulWidget {
  const SettingsTheme({super.key});

  @override
  State<SettingsTheme> createState() => _SettingsThemeState();
}

class _SettingsThemeState extends State<SettingsTheme> {
  bool? _previousIsDarkMode;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeValues(context).watch.isDarkMode;

    if (_previousIsDarkMode != null && _previousIsDarkMode != isDarkMode) {
      setState(() {});
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() => _previousIsDarkMode = isDarkMode),
    );

    return MyCard(
      color: ThemeValues(context).colorScheme.surfaceContainerHigh,
      elevation: 1,
      child: Padding(
        padding: Screen.padding.all,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Icon(
                    Icons.dark_mode,
                    color: ThemeValues(context).colorScheme.onSurface,
                  )
                  .animate(onPlay: (controller) => controller.reset())
                  .rotate(begin: 0, end: isDarkMode ? 3.14 : 0)
                  .fade(
                    begin: isDarkMode ? 1 : 0.5,
                    end: isDarkMode ? 0.5 : 1,
                    duration: Screen.duration,
                    curve: Screen.curve,
                  ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      'Theme',
                      color: ThemeValues(context).colorScheme.onSurface,
                      size: 18,
                    ),
                    const SizedBox(height: 10),
                    MyText(
                      'Set theme for your apps',
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              MySwitch(
                activeColor: ThemeValues(context).colorScheme.onPrimary,
                value: isDarkMode,
                onChanged: (_) => ThemeValues(context).read.toggleTheme(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
