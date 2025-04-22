import 'package:todolist/models/rive_model.dart';

class NavigationItemModel {
  final String title;
  final RiveModel rive;

  NavigationItemModel({required this.title, required this.rive});
}

List<NavigationItemModel> bottomNavigationItems = [
  NavigationItemModel(
    title: 'Home',
    rive: RiveModel(
      source: 'lib/assets/animations/icons.riv',
      artboard: 'HOME',
      stateMachineName: 'HOME_interactivity',
    ),
  ),
  NavigationItemModel(
    title: 'Settings',
    rive: RiveModel(
      source: 'lib/assets/animations/icons.riv',
      artboard: 'SETTINGS',
      stateMachineName: 'SETTINGS_Interactivity',
    ),
  ),
];
