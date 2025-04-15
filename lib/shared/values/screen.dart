import 'package:flutter/material.dart';

abstract class Screen {
  static _Padding get padding => _Padding();

  static double get infinity => double.infinity;
  static Duration get duration => const Duration(milliseconds: 300);
  static Cubic get curve => Curves.easeInOut;
}

class _Padding {
  static const double _value = 15;

  EdgeInsetsGeometry get all => EdgeInsets.all(_value);
  EdgeInsetsGeometry get horizontal => EdgeInsets.symmetric(horizontal: _value);
  EdgeInsetsGeometry get vertical => EdgeInsets.symmetric(vertical: _value);

  double get left => _value;
  double get right => _value;
  double get top => _value;
  double get bottom => _value;
}
