import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:todolist/models/navigation_item_model.dart';
import 'package:todolist/shared/values/main_values.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  final List<SMIBool> _riveIconInputs = [];
  final List<StateMachineController?> _controllers = [];

  @override
  void dispose() {
    _controllers.map((controller) => controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          );
        }),
      ),
    );
  }

  void _riveOnInit(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      stateMachineName,
    );

    artboard.addController(controller!);
    _controllers.add(controller);
    _riveIconInputs.add(controller.findInput<bool>('active') as SMIBool);
  }

  void _animateTheIcons(int index) {
    _riveIconInputs[index].change(true);
    Future.delayed(
      const Duration(seconds: 1),
      () => _riveIconInputs[index].change(false),
    );
  }

  Widget _buildAnimatedBar(bool isActive) => AnimatedContainer(
    duration: Screen.duration,
    margin: EdgeInsets.only(bottom: 2),
    height: 4,
    width: isActive ? 20 : 0,
    decoration: BoxDecoration(
      color: ThemeValues(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
