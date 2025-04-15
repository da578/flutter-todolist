import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/shared/components/my_alert_dialog.dart';
import 'package:todolist/shared/components/my_text.dart';
import '../../shared/values/main_values.dart';
import 'widgets/main_navigation_bar.dart';
import '../settings/settings_view.dart';
import '../task/task_view.dart';

/// MainView is the primary widget that acts as a container for all pages in the app.
/// It manages navigation between pages and handles the back button behavior on Android.
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  /// List of widgets representing the app's pages.
  final List<Widget> _views = const [TaskView(), SettingsView()];

  /// ValueNotifier to track whether the user has confirmed exiting the app.
  final _isConfirmed = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: _isConfirmed.value,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && mounted) {
            MyAlertDialog.show(
              context: context,
              isCancellable: true,
              title: 'Confirmation',
              content: MyText(
                'Are you sure want quit from this apps?',
                overflow: TextOverflow.visible,
              ),
              onPressed: () => SystemNavigator.pop(animated: true),
            );
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _views[MainValues(context).watch.currentIndex],
          transitionBuilder:
              (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
        ),
      ),
      bottomNavigationBar: MainNavigationBar(),
    );
  }
}
