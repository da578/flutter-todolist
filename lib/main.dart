import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/main_provider.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'repositories/task_repository.dart';
import 'services/notification_service.dart';
import 'shared/values/theme_values.dart';
import 'views/main/main_view.dart';

/// The main entry point of the application.
///
/// Initializes necessary services and providers before starting the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await TaskRepository().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const Main(),
    ),
  );
}

/// The root widget of the application.
///
/// Provides the overall theme configuration and routing setup.
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainView(),
      theme: ThemeValues(context).watch.themeData,
    );
  }
}
