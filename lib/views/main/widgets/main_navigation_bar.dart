import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../shared/values/main_values.dart';
import '../../../shared/values/screen.dart';
import '../../../shared/values/theme_values.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Screen.padding.all,
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: GNav(
          selectedIndex: MainValues(context).watch.currentIndex,
          onTabChange:
              (index) => MainValues(context).read.setCurrentIndex(index),
          tabMargin: const EdgeInsets.all(10),
          style: GnavStyle.google,
          backgroundColor:
              ThemeValues(context).colorScheme.surfaceContainerHigh,
          activeColor: ThemeValues(context).colorScheme.onPrimary,
          gap: 10,
          tabBackgroundColor: ThemeValues(context).colorScheme.primary,
          tabs: [
            GButton(icon: Icons.home, text: 'Home', haptic: false),
            GButton(icon: Icons.settings, text: 'Settings', haptic: false),
          ],
        ),
      ),
    );
  }
}
