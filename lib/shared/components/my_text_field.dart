import 'package:flutter/material.dart';
import 'package:todolist/shared/values/theme_values.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool autofocus;

  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: ThemeValues(context).colorScheme.onSurface,
          ),
        ),
        labelText: labelText,
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          gapPadding: 10,
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: ThemeValues(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      maxLines: 1,
      keyboardType: TextInputType.text,
      autofocus: autofocus,
    );
  }
}
