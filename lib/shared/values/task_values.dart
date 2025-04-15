import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';

class TaskValues {
  final BuildContext context;
  const TaskValues(this.context);

  TaskProvider get watch => context.watch<TaskProvider>();
  TaskProvider get read => context.read<TaskProvider>();
}
