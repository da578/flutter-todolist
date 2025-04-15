import 'package:flutter/material.dart';
import 'package:todolist/shared/values/theme_values.dart';

class MyBottomSheet {
  static Future<dynamic> show({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    AnimationController? animationController,
  }) {
    return showModalBottomSheet(
      backgroundColor: ThemeValues(context).colorScheme.surfaceContainerHigh,
      isScrollControlled: true,
      showDragHandle: true,
      transitionAnimationController: animationController,
      context: context,
      builder: builder,
    );
  }
}
