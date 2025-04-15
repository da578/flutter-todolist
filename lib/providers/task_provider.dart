import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todolist/shared/values/screen.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  Timer? _timer;
  bool _isSearching = false;
  bool _isSearchingBarAnimating = false;
  bool _isLoading = true;
  String _searchQuery = '';
  List<Task> _tasks = [];
  final Set<int> _createdIds = {};
  final Set<int> _updatedIds = {};
  final Set<int> _deletedIds = {};

  Timer? get timer => _timer;
  bool get isSearching => _isSearching;
  bool get isSearchBarAnimating => _isSearchingBarAnimating;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  List<Task> get tasks => _tasks;
  Set<int> get createdIds => _createdIds;
  Set<int> get updatedIds => _updatedIds;
  Set<int> get deletedIds => _deletedIds;

  void setTimer(Timer? value) {
    _timer = value;
    notifyListeners();
  }

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

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setTasks(List<Task> value) {
    _tasks = value;
    notifyListeners();
  }

  void setCreatedIds(Set<int> value) {
    _createdIds.addAll(value);
    notifyListeners();
  }

  void setUpdatedIds(Set<int> value) {
    _updatedIds.addAll(value);
    notifyListeners();
  }

  void setDeletedIds(Set<int> value) {
    _deletedIds.addAll(value);
    notifyListeners();
  }

  void reset() {
    _createdIds.clear();
    _updatedIds.clear();
    _deletedIds.clear();
    notifyListeners();
  }
}
