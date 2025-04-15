import 'package:flutter/material.dart';

class MediaValues {
  final BuildContext context;
  const MediaValues(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get bottom => MediaQuery.of(context).viewInsets.bottom + 15;
}
