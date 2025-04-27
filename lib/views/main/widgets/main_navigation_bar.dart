import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:todolist/models/rive_model.dart';
import 'package:todolist/shared/values/main_values.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';

/// Internal model for navigation items containing the title and Rive model.
class _NavigationItemModel {
  final String title;
  final RiveModel rive;

  _NavigationItemModel({required this.title, required this.rive});
}

/// Main navigation bar widget that uses Rive animations for icons.
class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  /// List to hold the Rive icon inputs for animation control.
  late final List<SMIBool> _riveIconInputs;

  /// List to hold the state machine controllers for each icon.
  late final List<StateMachineController?> _controllers;

  @override
  void initState() {
    super.initState();
    _riveIconInputs = [];
    _controllers = [];
  }

  @override
  void dispose() {
    // Dispose all controllers when the widget is removed from the tree.
    for (final controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<_NavigationItemModel> bottomNavigationItems = [
      _NavigationItemModel(
        title: 'Home',
        rive: RiveModel(
          source: 'lib/assets/animations/icons.riv',
          artboard: 'HOME',
          stateMachineName: 'HOME_interactivity',
        ),
      ),
      _NavigationItemModel(
        title: 'Settings',
        rive: RiveModel(
          source: 'lib/assets/animations/icons.riv',
          artboard: 'SETTINGS',
          stateMachineName: 'SETTINGS_Interactivity',
        ),
      ),
    ];

    return Container(
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(15),
      height: 75,
      decoration: BoxDecoration(
        color: ThemeValues(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(bottomNavigationItems.length, (index) {
          final riveIcon = bottomNavigationItems[index].rive;

          return GestureDetector(
            onTap: () {
              _animateTheIcons(index);
              MainValues(context).read.setCurrentIndex(index);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedBar(
                  MainValues(context).watch.currentIndex == index,
                ),
                SizedBox(
                  height: 36,
                  width: 36,
                  child: Opacity(
                    opacity:
                        MainValues(context).watch.currentIndex == index
                            ? 1
                            : 0.5,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        ThemeValues(context).colorScheme.onSurface,
                        BlendMode.srcATop,
                      ),
                      child: RiveAnimation.asset(
                        antialiasing: true,
                        riveIcon.source,
                        artboard: riveIcon.artboard,
                        onInit: (artboard) {
                          _riveOnInit(
                            artboard,
                            stateMachineName: riveIcon.stateMachineName,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Initializes the Rive animation with the given state machine name.
  void _riveOnInit(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      stateMachineName,
    );

    if (controller != null) {
      artboard.addController(controller);
      _controllers.add(controller);
      _riveIconInputs.add(controller.findInput<bool>('active') as SMIBool);
    }
  }

  /// Animates the icon at the specified index.
  void _animateTheIcons(int index) {
    _riveIconInputs[index].change(true);
    Future.delayed(
      const Duration(seconds: 1),
      () => _riveIconInputs[index].change(false),
    );
  }

  /// Builds an animated bar that appears below the active icon.
  Widget _buildAnimatedBar(bool isActive) => AnimatedContainer(
    duration: Screen.duration,
    margin: const EdgeInsets.only(bottom: 2),
    height: 4,
    width: isActive ? 20 : 0,
    decoration: BoxDecoration(
      color: ThemeValues(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
