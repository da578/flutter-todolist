import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todolist/shared/values/media_values.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/task_values.dart';
import 'package:todolist/shared/values/theme_values.dart';

/// TaskSearchBar is a custom search bar that allows users to search for tasks.
///
/// This widget supports debouncing and smooth transitions between search and normal modes.
/// It dynamically adjusts its appearance based on the current search state.
class TaskSearchBar extends StatefulWidget {
  const TaskSearchBar({super.key});

  @override
  State<TaskSearchBar> createState() => _TaskSearchBarState();
}

class _TaskSearchBarState extends State<TaskSearchBar> {
  /// The text controller used to manage the search input field.
  late final TextEditingController _controller;

  /// A timer used for debouncing search queries.
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    // Initialize the text controller and add a listener for debouncing.
    _controller = TextEditingController();
    _controller.addListener(_onSearchTextChanged);
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
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    _debounceTimer = Timer(
      Screen.duration,
      () => TaskValues(context).read.setSearchQuery(_controller.text),
    );
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
      child: _buildSearchBar(),
    );
  }

  /// Builds the search bar UI based on the current search state.
  ///
  /// If the app is in search mode, it displays a full-width search bar.
  /// Otherwise, it displays an icon button to toggle search mode.
  Widget _buildSearchBar() {
    if (TaskValues(context).watch.isSearching) {
      return Container(
        padding: Screen.padding.horizontal,
        width: MediaValues(context).width,
        alignment: Alignment.center,
        child: SearchBar(
          onChanged: (query) => TaskValues(context).read.setSearchQuery(query),
          elevation: const WidgetStatePropertyAll(1),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 15),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _exitSearchMode,
          ),
          trailing: [
            IconButton(icon: Icon(Icons.clear), onPressed: _clearSearchQuery),
          ],
          hintText: 'Search',
          controller: _controller,
        ),
      );
    } else {
      return IconButton(
        icon: Icon(Icons.search),
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(
            ThemeValues(context).colorScheme.onSurface,
          ),
        ),
        onPressed: _enterSearchMode,
      );
    }
  }

  /// Enters search mode by updating the state and showing the search bar.
  void _enterSearchMode() => TaskValues(context).read.setIsSearching(true);

  /// Exits search mode by clearing the search query and hiding the search bar.
  void _exitSearchMode() {
    _controller.clear();
    TaskValues(context).read.setIsSearching(false);
  }

  /// Clears the current search query without exiting search mode.
  void _clearSearchQuery() {
    _controller.clear();
    TaskValues(context).read.setSearchQuery('');
  }
}
