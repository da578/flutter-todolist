import 'package:flutter/material.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/shared/components/my_app_bar.dart';
import 'package:todolist/shared/components/my_bottom_sheet.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/task_values.dart';
import 'package:todolist/shared/values/theme_values.dart';
import 'package:todolist/views/task/widgets/task_create.dart';
import 'package:todolist/views/task/widgets/task_export.dart';
import 'package:todolist/views/task/widgets/task_import.dart';
import 'package:todolist/views/task/widgets/task_search_bar.dart';

/// TaskAppBar is the custom app bar for the task screen.
/// It includes a search bar, a title, and additional actions like create, export, and import tasks.
class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The animation controller used for UI transitions.
  final AnimationController _animationController;

  /// The presenter responsible for handling business logic related to tasks.
  final TaskPresenterContract _presenter;

  /// Constructor for [TaskAppBar].
  ///
  /// Requires an [AnimationController] for animations and a [TaskPresenterContract] for task-related operations.
  const TaskAppBar({
    super.key,
    required AnimationController animationController,
    required TaskPresenterContract presenter,
  }) : _animationController = animationController,
       _presenter = presenter;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return MyAppBar(
      title: TaskValues(context).watch.isSearching ? '' : 'To Do List App',
      actions: [
        TaskSearchBar(),
        Visibility(
          visible:
              !TaskValues(context).watch.isSearching &&
              !TaskValues(context).watch.isSearchBarAnimating,
          child: PopupMenuButton(
            borderRadius: BorderRadius.circular(20),
            color: ThemeValues(context).colorScheme.surfaceContainerHigh,
            icon: Icon(
              Icons.more_vert_rounded,
              color: ThemeValues(context).colorScheme.onSurface,
            ),
            elevation: 1,
            itemBuilder:
                (_) => [
                  PopupMenuItem(
                    onTap:
                        () => MyBottomSheet.show(
                          context: context,
                          animationController: _animationController,
                          builder: (_) => TaskCreate(presenter: _presenter),
                        ),
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        const SizedBox(width: 10),
                        MyText('Create'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      if (!context.mounted) return;
                      MyBottomSheet.show(
                        context: context,
                        builder: (_) => TaskExport(presenter: _presenter),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.upload),
                        const SizedBox(width: 10),
                        MyText('Export'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap:
                        () async => MyBottomSheet.show(
                          context: context,
                          builder: (_) => TaskImport(presenter: _presenter),
                        ),
                    child: Row(
                      children: [
                        Icon(Icons.download),
                        const SizedBox(width: 10),
                        MyText('Import'),
                      ],
                    ),
                  ),
                ],
          ),
        ),
      ],
    );
  }
}
