import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/main_provider.dart';

class MainValues {
  final BuildContext context;
  const MainValues(this.context);

  MainProvider get watch => context.watch<MainProvider>();
  MainProvider get read => context.read<MainProvider>();
}
