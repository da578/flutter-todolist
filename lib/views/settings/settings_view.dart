import 'package:flutter/material.dart';
import 'package:todolist/shared/components/my_app_bar.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/views/settings/settings_about.dart';
import 'package:todolist/views/settings/settings_theme.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      SettingsTheme(),
      SizedBox(height: 10),
      SettingsAbout(),
    ];

    return Scaffold(
      appBar: const MyAppBar(title: 'Settings'),
      body: Padding(
        padding: Screen.padding.all,
        child: ListView.builder(
          itemCount: pages.length,
          itemBuilder: (_, index) => pages[index],
        ),
      ),
    );
  }
}
