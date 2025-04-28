import 'package:flutter/material.dart';
import 'package:todolist/shared/components/my_filled_button.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/theme_values.dart';

/// Custom alert dialog widget that uses `MyText` and `MyFilledButton` components.
class MyAlertDialog extends StatelessWidget {
  /// Title of the alert dialog.
  final String title;

  /// Content widget to be displayed in the alert dialog.
  final Widget? content;

  /// List of action buttons to be displayed at the bottom of the alert dialog.
  final List<Widget>? actions;

  /// Constructor to create a new `MyAlertDialog` instance.
  ///
  /// - [title]: The title of the alert dialog (required).
  /// - [content]: The content widget to be displayed (required).
  /// - [actions]: List of action buttons to be displayed (required).
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

  /// Static method to show a custom alert dialog.
  ///
  /// - [context]: The `BuildContext` of the calling widget (required).
  /// - [title]: The title of the alert dialog (required).
  /// - [content]: The content widget to be displayed (required).
  /// - [isCancellable]: Whether the dialog can be dismissed by tapping outside (default: `false`).
  /// - [onPressed]: Callback function to be executed when the confirm button is pressed (required).
  /// - [onPressedCancellable]: Callback function to be executed when the cancel button is pressed (optional).
  /// - [confirmButtonText]: Text for the confirm button (default: 'Yes').
  /// - [cancelButtonText]: Text for the cancel button (default: 'No').
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
          (dialogContext) => AlertDialog(
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
                    Navigator.pop(dialogContext);
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
                  Navigator.pop(dialogContext);
                  onPressed();
                },
              ),
            ],
          ),
    );
  }
}
