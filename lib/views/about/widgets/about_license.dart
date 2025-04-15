import 'package:flutter/material.dart';
import 'package:todolist/shared/components/my_alert_dialog.dart';
import 'package:todolist/shared/components/my_card.dart';
import 'package:todolist/shared/components/my_filled_button.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';

class AboutLicense extends StatelessWidget {
  const AboutLicense({super.key});

  @override
  Widget build(BuildContext context) {
    const String license = '''
MIT License

Copyright (c) 2023 Dzulkifli Anwar

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
''';

    return GestureDetector(
      onTap:
          () => showDialog(
            context: context,
            builder:
                (context) => MyAlertDialog(
                  title: 'MIT License',
                  content: MyText(license, overflow: TextOverflow.visible),
                  actions: [
                    MyFilledButton(
                      backgroundColor: WidgetStatePropertyAll(
                        ThemeValues(context).colorScheme.primary,
                      ),
                      child: MyText(
                        'Okay',
                        color: ThemeValues(context).colorScheme.onPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
          ),
      child: MyCard(
        color: ThemeValues(context).colorScheme.surfaceContainerHigh,
        elevation: 1,
        child: Padding(
          padding: Screen.padding.all,
          child: Row(
            children: [
              Icon(
                Icons.copyright,
                size: 30,
                color: ThemeValues(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    'License',
                    color: ThemeValues(context).colorScheme.onSurface,
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(width: 10),
                  MyText(
                    'MIT License',
                    color: ThemeValues(context).colorScheme.onSurface,
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
