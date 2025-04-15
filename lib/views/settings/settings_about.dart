import 'package:flutter/material.dart';
import 'package:todolist/shared/components/my_card.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';
import 'package:todolist/views/about/about_view.dart';

class SettingsAbout extends StatelessWidget {
  const SettingsAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, _, _) => AboutView(),
            transitionsBuilder:
                (_, animation, _, child) =>
                    FadeTransition(opacity: animation, child: child),
            transitionDuration: Screen.duration,
          ),
        );
      },
      child: MyCard(
        color: ThemeValues(context).colorScheme.surfaceContainerHigh,
        elevation: 1,
        child: Padding(
          padding: Screen.padding.all,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Icon(
                  Icons.question_mark_outlined,
                  color: ThemeValues(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        'About',
                        color: ThemeValues(context).colorScheme.onSurface,
                        size: 18,
                      ),
                      const SizedBox(height: 10),
                      MyText(
                        'See the developer behind this apps',
                        color: ThemeValues(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
