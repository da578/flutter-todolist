import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:todolist/shared/components/my_app_bar.dart';
import 'package:todolist/shared/components/my_filled_button.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';
import 'package:todolist/views/about/widgets/about_donation.dart';
import 'package:todolist/views/about/widgets/about_message.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'About'),
      body: SingleChildScrollView(
        child: Padding(
          padding: Screen.padding.all,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'lib/assets/images/profile.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                const SizedBox(height: 25),
                MyText('Dzulkifli Anwar', size: 25, weight: FontWeight.bold),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: MyFilledButton(
                    backgroundColor: WidgetStatePropertyAll(Colors.green[500]),
                    child: Row(
                      children: [
                        const Spacer(),
                        Icon(Icons.phone, color: Colors.white),
                        const SizedBox(width: 10),
                        MyText(
                          'WhatsApp',
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        const Spacer(),
                      ],
                    ),
                    onPressed: () async {
                      final url = 'https://wa.me/+6287878235416';
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
                  ),
                ),
                const SizedBox(height: 15),
                const AboutMessage(),
                const SizedBox(height: 10),
                const AboutDonation(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
