import 'package:flutter/material.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/shared/components/my_app_bar.dart';
import 'package:todolist/shared/values/task_values.dart';
import 'package:todolist/views/task/widgets/task_menu.dart';
import 'package:todolist/views/task/widgets/task_search_bar.dart';
import 'package:todolist/views/task/widgets/task_sort.dart';

/// TaskAppBar is the custom app bar for the task screen.
///
/// This widget includes a search bar, a title, and additional actions like create,
/// export, and import tasks. It dynamically adjusts its content based on the current
/// state (e.g., search mode or animation state).
class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The animation controller used for UI transitions.
  final AnimationController _animationController;

  /// The presenter responsible for handling business logic related to tasks.
  final TaskPresenterContract _presenter;

  /// Constructor for [TaskAppBar].
  ///
  /// Parameters:
  /// - [animationController]: The controller for animations.
  /// - [presenter]: The task presenter for handling business logic.
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
    // Access the current state of the task values.
    final taskValues = TaskValues(context).watch;
    final isSearching = taskValues.isSearching;
    final isSearchBarAnimating = taskValues.isSearchBarAnimating;

    return MyAppBar(
      title: isSearching ? '' : 'To Do List App',
      actions: [
        // Search bar is always visible.
        TaskSearchBar(),
        // Sort button is visible only when not in search mode or animating.
        Visibility(
          visible: !isSearching && !isSearchBarAnimating,
          child: TaskSort(presenter: _presenter),
        ),
        // Menu button is visible only when not in search mode or animating.
        Visibility(
          visible: !isSearching && !isSearchBarAnimating,
          child: TaskMenu(
            animationController: _animationController,
            presenter: _presenter,
          ),
        ),
      ],
    );
  }
}
