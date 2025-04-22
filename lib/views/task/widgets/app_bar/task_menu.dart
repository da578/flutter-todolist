import 'package:flutter/material.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/shared/components/my_bottom_sheet.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/task_values.dart';
import 'package:todolist/shared/values/theme_values.dart';
import 'package:todolist/views/task/widgets/task_create.dart';
import 'package:todolist/views/task/widgets/task_export.dart';
import 'package:todolist/views/task/widgets/task_import.dart';

/// TaskMenu is a popup menu that provides options for creating, exporting, and importing tasks.
///
/// This widget is displayed as an action button in the app bar and allows users to:
/// - Create a new task.
/// - Export tasks to a file.
/// - Import tasks from a file.
class TaskMenu extends StatefulWidget {
  /// The presenter responsible for handling business logic related to tasks.
  final TaskPresenterContract _presenter;

  /// Constructor for [TaskMenu].
  ///
  /// Parameters:
  /// - [presenter]: The task presenter for handling business logic.
  const TaskMenu({super.key, required TaskPresenterContract presenter})
    : _presenter = presenter;

  @override
  State<TaskMenu> createState() => _TaskMenuState();
}

class _TaskMenuState extends State<TaskMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Screen.duration,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      borderRadius: BorderRadius.circular(20),
      color: ThemeValues(context).colorScheme.surfaceContainerHigh,
      icon: Icon(
        Icons.more_vert_rounded,
        color: ThemeValues(context).colorScheme.onSurface,
      ),
      elevation: 1,
      itemBuilder:
          (_) => [
            _buildCreateMenuItem(context),
            _buildExportMenuItem(context),
            _buildImportMenuItem(context),
          ],
    );
  }

  /// Builds the "Create" menu item.
  ///
  /// When tapped, it shows a bottom sheet for creating a new task.
  PopupMenuItem<void> _buildCreateMenuItem(BuildContext context) {
    return PopupMenuItem(
      onTap: () {
        // Set isCreating to true before showing the bottom sheet
        TaskValues(context).read.setIsCreating(true);

        MyBottomSheet.show(
          context: context,
          animationController: _animationController,
          builder: (_) => TaskCreate(presenter: widget._presenter),
        ).whenComplete(() {
          // Reset isCreating to false when the bottom sheet is closed
          if (context.mounted) TaskValues(context).read.setIsCreating(false);
        });
      },
      child: Row(
        children: [
          Icon(Icons.add, color: ThemeValues(context).colorScheme.onSurface),
          const SizedBox(width: 10),
          MyText('Create', color: ThemeValues(context).colorScheme.onSurface),
        ],
      ),
    );
  }

  /// Builds the "Export" menu item.
  ///
  /// When tapped, it shows a bottom sheet for exporting tasks.
  PopupMenuItem<void> _buildExportMenuItem(BuildContext context) {
    return PopupMenuItem(
      onTap: () async {
        // Set isExporting to true before showing the bottom sheet
        TaskValues(context).read.setIsExporting(true);

        MyBottomSheet.show(
          context: context,
          builder: (_) => TaskExport(presenter: widget._presenter),
        ).whenComplete(() {
          // Reset isExporting to false when the bottom sheet is closed
          if (context.mounted) TaskValues(context).read.setIsExporting(false);
        });
      },
      child: Row(
        children: [
          Icon(Icons.upload, color: ThemeValues(context).colorScheme.onSurface),
          const SizedBox(width: 10),
          MyText('Export', color: ThemeValues(context).colorScheme.onSurface),
        ],
      ),
    );
  }

  /// Builds the "Import" menu item.
  ///
  /// When tapped, it shows a bottom sheet for importing tasks.
  PopupMenuItem<void> _buildImportMenuItem(BuildContext context) {
    return PopupMenuItem(
      onTap: () async {
        // Set isImporting to true before showing the bottom sheet
        TaskValues(context).read.setIsImporting(true);

        MyBottomSheet.show(
          context: context,
          builder: (_) => TaskImport(presenter: widget._presenter),
        ).whenComplete(() {
          // Reset isImporting to false when the bottom sheet is closed
          if (context.mounted) TaskValues(context).read.setIsImporting(false);
        });
      },
      child: Row(
        children: [
          Icon(
            Icons.download,
            color: ThemeValues(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 10),
          MyText('Import', color: ThemeValues(context).colorScheme.onSurface),
        ],
      ),
    );
  }
}
