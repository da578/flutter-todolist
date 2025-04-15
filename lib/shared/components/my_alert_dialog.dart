import 'package:flutter/material.dart';
import 'package:todolist/shared/components/my_filled_button.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/theme_values.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final List<Widget>? actions;

  const MyAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: MyText(title, size: 23),
      content: SingleChildScrollView(child: content),
      actions: actions,
    );
  }

  static dynamic show({
    required BuildContext context,
    required String title,
    required Widget content,
    bool isCancellable = false,
    required VoidCallback onPressed,
    VoidCallback? onPressedCancellable,
    String confirmButtonText = 'Yes',
    String cancelButtonText = 'No',
  }) {
    showDialog(
      context: context,
      barrierDismissible: isCancellable,
      builder:
          (_) => AlertDialog(
            title: MyText(title, size: 23),
            content: SingleChildScrollView(child: content),
            actions: [
              if (isCancellable)
                OutlinedButton(
                  style: ButtonStyle(
                    side: WidgetStatePropertyAll(
                      BorderSide(color: ThemeValues(context).colorScheme.error),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (onPressedCancellable != null) {
                      onPressedCancellable();
                    }
                  },
                  child: MyText(
                    cancelButtonText,
                    color: ThemeValues(context).colorScheme.error,
                    weight: FontWeight.bold,
                  ),
                ),
              MyFilledButton(
                backgroundColor: WidgetStatePropertyAll(
                  ThemeValues(context).colorScheme.primary,
                ),
                child: MyText(
                  confirmButtonText,
                  color: ThemeValues(context).colorScheme.onPrimary,
                  weight: FontWeight.bold,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onPressed();
                },
              ),
            ],
          ),
    );
  }
}
