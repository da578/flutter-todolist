import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todolist/shared/values/screen.dart';
import '../models/task.dart';

/// A provider class for managing the state of tasks in the application.
///
/// This class uses [ChangeNotifier] to notify listeners when the state changes.
/// It manages task data, search functionality, loading states, and animations.
class TaskProvider with ChangeNotifier {
  /// The current search query applied to filter tasks.
  String _searchQuery = '';

  /// The complete list of tasks fetched from the repository.
  List<Task> _tasks = [];

  /// The filtered list of tasks based on the search query.
  List<Task> _filteredTasks = [];

  /// Indicates whether a task creation bottom sheet is currently open.
  bool _isCreating = false;

  /// Indicates whether a task export bottom sheet is currently open.
  bool _isExporting = false;

  /// Indicates whether a task import bottom sheet is currently open.
  bool _isImporting = false;

  /// Indicates whether the app is currently in search mode.
  bool _isSearching = false;

  /// Indicates whether the search bar is animating.
  bool _isSearchingBarAnimating = false;

  /// Indicates whether tasks are currently being loaded.
  bool _isLoading = true;

  /// IDs of tasks that have been created during the current session.
  final Set<int> _createdIds = {};

  /// IDs of tasks that have been updated during the current session.
  final Set<int> _updatedIds = {};

  /// IDs of tasks that have been deleted during the current session.
  final Set<int> _deletedIds = {};

  /// Returns the current search query.
  String get searchQuery => _searchQuery;

  /// Returns the complete list of tasks.
  List<Task> get tasks => _tasks;

  /// Returns the filtered list of tasks based on the search query.
  List<Task> get filteredTasks => _filteredTasks;

  /// Returns whether a task creation bottom sheet is currently open.
  bool get isCreating => _isCreating;

  /// Returns whether a task export bottom sheet is currently open.
  bool get isExporting => _isExporting;

  /// Returns whether a task import bottom sheet is currently open.
  bool get isImporting => _isImporting;

  /// Returns whether the app is currently in search mode.
  bool get isSearching => _isSearching;

  /// Returns whether the search bar is currently animating.
  bool get isSearchBarAnimating => _isSearchingBarAnimating;

  /// Returns whether tasks are currently being loaded.
  bool get isLoading => _isLoading;

  /// Returns the IDs of tasks that have been created during the current session.
  Set<int> get createdIds => _createdIds;

  /// Returns the IDs of tasks that have been updated during the current session.
  Set<int> get updatedIds => _updatedIds;

  /// Returns the IDs of tasks that have been deleted during the current session.
  Set<int> get deletedIds => _deletedIds;

  /// Sets the state of task creation.
  ///
  /// Parameters:
  /// - [value]: Whether a task creation bottom sheet is open.
  void setIsCreating(bool value) {
    if (_isCreating != value) {
      _isCreating = value;
      notifyListeners();
    }
  }

  /// Sets the state of task export.
  ///
  /// Parameters:
  /// - [value]: Whether a task export bottom sheet is open.
  void setIsExporting(bool value) {
    if (_isExporting != value) {
      _isExporting = value;
      notifyListeners();
    }
  }

  /// Sets the state of task import.
  ///
  /// Parameters:
  /// - [value]: Whether a task import bottom sheet is open.
  void setIsImporting(bool value) {
    if (_isImporting != value) {
      _isImporting = value;
      notifyListeners();
    }
  }

  /// Sets the search mode state.
  ///
  /// Parameters:
  /// - [value]: Whether the app should enter or exit search mode.
  void setIsSearching(bool value) {
    if (_isSearching != value) {
      _isSearching = value;

      if (!value) {
        _isSearchingBarAnimating = true;
        Future.delayed(Screen.duration, () {
          _isSearchingBarAnimating = false;
          notifyListeners();
        });
      } else {
        notifyListeners();
      }
    }
  }

  /// Updates the search query and filters tasks accordingly.
  ///
  /// Parameters:
  /// - [value]: The new search query.
  void setSearchQuery(String value) {
    _searchQuery = value.toLowerCase();
    _filterTasks();
    notifyListeners();
  }

  /// Filters tasks based on the current search query.
  ///
  /// If the search query is empty, all tasks are returned.
  /// Otherwise, tasks whose names contain the search query are returned.
  void _filterTasks() {
    if (_searchQuery.isEmpty) {
      _filteredTasks = List.from(_tasks);
    } else {
      _filteredTasks =
          _tasks
              .where((task) => task.name.toLowerCase().contains(_searchQuery))
              .toList();
    }
  }

  /// Updates the list of tasks and applies filtering.
  ///
  /// Parameters:
  /// - [value]: The new list of tasks.
  void setTasks(List<Task> value) {
    _tasks = value;
    _filterTasks();
    notifyListeners();
  }

  /// Sets the loading state.
  ///
  /// Parameters:
  /// - [value]: Whether tasks are currently being loaded.
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Updates the filtered list of tasks directly.
  ///
  /// Parameters:
  /// - [value]: The new filtered list of tasks.
  void setFilteredTasks(List<Task> value) {
    _filteredTasks = value;
    notifyListeners();
  }

  /// Adds task IDs to the set of created task IDs.
  ///
  /// Parameters:
  /// - [value]: The set of task IDs to add.
  void setCreatedIds(Set<int> value) {
    _createdIds.addAll(value);
    notifyListeners();
  }

  /// Adds task IDs to the set of updated task IDs.
  ///
  /// Parameters:
  /// - [value]: The set of task IDs to add.
  void setUpdatedIds(Set<int> value) {
    _updatedIds.addAll(value);
    notifyListeners();
  }

  /// Adds task IDs to the set of deleted task IDs.
  ///
  /// Parameters:
  /// - [value]: The set of task IDs to add.
  void setDeletedIds(Set<int> value) {
    _deletedIds.addAll(value);
    notifyListeners();
  }

  /// Resets the state of created, updated, and deleted task IDs.
  ///
  /// Clears all sets and notifies listeners.
  void reset() {
    _createdIds.clear();
    _updatedIds.clear();
    _deletedIds.clear();
    notifyListeners();
  }
}
