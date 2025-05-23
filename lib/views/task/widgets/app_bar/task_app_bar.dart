import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/shared/components/my_app_bar.dart';
import 'package:todolist/shared/components/my_bottom_sheet.dart';
import 'package:todolist/shared/values/media_values.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/task_values.dart';
import 'package:todolist/shared/values/theme_values.dart';
import 'package:todolist/views/task/widgets/app_bar/task_menu.dart';
import 'package:todolist/views/task/widgets/app_bar/task_sort.dart';
import 'package:todolist/views/task/widgets/task_create.dart';

/// TaskAppBar is the custom app bar for the task screen.
///
/// This widget includes a search bar, a title, and additional actions like create,
/// export, and import tasks. It dynamically adjusts its content based on the current
/// state (e.g., search mode or animation state).
class TaskAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<TaskAppBar> createState() => _TaskAppBarState();
}

class _TaskAppBarState extends State<TaskAppBar>
    with SingleTickerProviderStateMixin {
  /// The text controller used to manage the search input field.
  late final TextEditingController _controller;

  late final AnimationController _animationController;

  /// A timer used for debouncing search queries.
  Timer? _debounceTimer;

  /// Indicates whether the app bar is in search mode.
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    // Initialize the text controller and add a listener for debouncing.
    _controller = TextEditingController()..addListener(_onSearchTextChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: Screen.duration,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Handles changes in the search input field with debouncing.
  ///
  /// Debouncing ensures that the search query is only applied after the user
  /// has stopped typing for a specified duration.
  void _onSearchTextChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(
      Screen.duration,
      () => TaskValues(context).read.setSearchQuery(_controller.text),
    );
  }

  /// Toggles between search mode and normal mode.
  ///
  /// When toggling, it animates the app bar using the [AnimationController].
  void _toggleSearchMode() {
    setState(() => _isSearching = !_isSearching);
    _isSearching
        ? widget._animationController.forward()
        : widget._animationController.reverse();
  }

  @override
  Widget build(BuildContext context) => MyAppBar(
    title: _isSearching ? '' : 'ToDayLy',
    actions: [
      AnimatedBuilder(
        animation: widget._animationController,
        builder: (_, __) => _buildSearchBar(widget._animationController.value),
      ),
      IconButton(
        onPressed: () {
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
        icon: Icon(Icons.note_add_rounded),
        color: ThemeValues(context).colorScheme.onSurface,
      ),
      TaskMenu(presenter: widget._presenter),
    ],
  );

  /// Builds the search bar UI based on the current animation value.
  ///
  /// Parameters:
  /// - [animationValue]: The current value of the animation controller.
  ///
  /// Returns a widget representing the search bar.
  Widget _buildSearchBar(double animationValue) => ClipRRect(
    clipBehavior: Clip.antiAlias,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: Offset(animationValue * -50, 0),
          child:
              !_isSearching
                  ? IconButton(
                    onPressed: _toggleSearchMode,
                    icon: Icon(Icons.search),
                    color: ThemeValues(context).colorScheme.onSurface,
                  )
                  : null,
        ),
        Opacity(
          opacity: animationValue,
          child: Container(
            width: (MediaValues(context).width * 70 / 100) * animationValue,
            height: 50,
            padding: Screen.padding.horizontal,
            decoration: BoxDecoration(
              color: ThemeValues(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _toggleSearchMode,
                  color: ThemeValues(context).colorScheme.onSurface,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: _isSearching,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Visibility(
                  visible: _isSearching,
                  child: TaskSort(presenter: widget._presenter),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
