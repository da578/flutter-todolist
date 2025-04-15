import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todolist/shared/values/media_values.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/task_values.dart';
import 'package:todolist/shared/values/theme_values.dart';

/// TaskSearchBar is a custom search bar that allows users to search for tasks.
/// It supports debouncing and smooth transitions between search and normal modes.
class TaskSearchBar extends StatefulWidget {
  const TaskSearchBar({super.key});

  @override
  State<TaskSearchBar> createState() => _TaskSearchBarState();
}

class _TaskSearchBarState extends State<TaskSearchBar> {
  /// The text controller used to manage the search input field.
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the text controller and add a listener for debouncing.
    _controller = TextEditingController();
    _controller.addListener(() {
      if (TaskValues(context).read.timer?.isActive ?? false) {
        TaskValues(context).read.timer?.cancel();
      }

      TaskValues(context).read.setTimer(
        Timer(const Duration(milliseconds: 500), () {
          final query = _controller.text.toLowerCase();
          TaskValues(context).read.setSearchQuery(query);
        }),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Screen.duration,
      transitionBuilder:
          (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
      child:
          TaskValues(context).watch.isSearching
              ? Container(
                padding: Screen.padding.horizontal,
                width: MediaValues(context).width,
                alignment: Alignment.center,
                child: SearchBar(
                  elevation: WidgetStatePropertyAll(1),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  padding: WidgetStatePropertyAll(
                    const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      _controller.clear();
                      TaskValues(context).read.setIsSearching(false);
                    },
                  ),
                  trailing: [
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _controller.clear(),
                    ),
                  ],
                  hintText: 'Search',
                  controller: _controller,
                ),
              )
              : IconButton(
                icon: Icon(Icons.search),
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(
                    ThemeValues(context).colorScheme.onSurface,
                  ),
                ),
                onPressed: () => TaskValues(context).read.setIsSearching(true),
              ),
    );
  }
}
