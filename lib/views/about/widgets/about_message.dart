import 'package:flutter/material.dart';
import 'package:todolist/shared/components/my_card.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';

class AboutMessage extends StatelessWidget {
  const AboutMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyCard(
      color: ThemeValues(context).colorScheme.surfaceContainerHigh,
      elevation: 1,
      child: Padding(
        padding: Screen.padding.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              'Message',
              size: 25,
              weight: FontWeight.bold,
              color: ThemeValues(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 15),
            MyText(
              'Hello Users,\n\nI am the indie developer of this To Do List app. This is my first app as a mobile developer. So, I am very happy if users give feedback on the contacts that are already available on this page.\n\nIf you are happy with this app, please help this developer by sharing the app and giving good and appropriate feedback. Or if you have a lot of money, you can donate on this page.',
              color: ThemeValues(context).colorScheme.onSurface,
              size: 16,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
