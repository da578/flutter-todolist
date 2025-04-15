import 'package:flutter/material.dart';

class MainProvider with ChangeNotifier {
  int _currentIndex = 0;
  int _previousIndex = 0;
  int get currentIndex => _currentIndex;
  int get previousIndex => _previousIndex;

  void setCurrentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  void setPreviousIndex(int value) {
    _previousIndex = value;
    notifyListeners();
  }
}
