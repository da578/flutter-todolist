import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:todolist/shared/components/my_card.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';

class AboutDonation extends StatelessWidget {
  const AboutDonation({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final url = 'https://saweria.co/da578';
        await FlutterWebBrowser.openWebPage(
          url: url,
          customTabsOptions: CustomTabsOptions(
            colorScheme:
                ThemeValues(context).read.isDarkMode
                    ? CustomTabsColorScheme.dark
                    : CustomTabsColorScheme.light,
          ),
        );
      },
      child: MyCard(
        color: ThemeValues(context).colorScheme.surfaceContainerHigh,
        elevation: 1,
        child: Padding(
          padding: Screen.padding.all,
          child: Row(
            children: [
              Icon(
                Icons.attach_money_rounded,
                size: 30,
                color: ThemeValues(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    'Donation',
                    color: ThemeValues(context).colorScheme.onSurface,
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 10),
                  MyText(
                    'Click here to donate!',
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
