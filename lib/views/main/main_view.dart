import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist/shared/components/my_alert_dialog.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/views/main/widgets/main_navigation_bar.dart';
import '../../shared/values/main_values.dart';
import '../settings/settings_view.dart';
import '../task/task_view.dart';

/// MainView is the primary widget that acts as a container for all pages in the app.
///
/// This widget manages navigation between pages and handles the back button behavior on Android.
/// It uses an animated transition to switch between pages and displays a confirmation dialog
/// when the user attempts to exit the app.
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  /// List of widgets representing the app's pages.
  final List<Widget> _views = const [TaskView(), SettingsView()];

  /// ValueNotifier to track whether the user has confirmed exiting the app.
  final ValueNotifier<bool> _isConfirmed = ValueNotifier(false);

  @override
  void dispose() {
    _isConfirmed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: _isConfirmed.value,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && mounted) {
            _showExitConfirmationDialog(context);
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
      bottomNavigationBar: const MainNavigationBar(),
    );
  }

  /// Displays a confirmation dialog when the user attempts to exit the app.
  ///
  /// The dialog includes an animation and a message asking the user to confirm their action.
  void _showExitConfirmationDialog(BuildContext context) {
    MyAlertDialog.show(
      context: context,
      isCancellable: true,
      title: 'Confirmation',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('lib/assets/animations/close.json', height: 125),
          MyText(
            'Are you sure you want to quit this app?',
            overflow: TextOverflow.visible,
          ),
        ],
      ),
      onPressed: () {
        _isConfirmed.value = true;
        SystemNavigator.pop(animated: true);
      },
    );
  }
}
