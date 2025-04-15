import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/components/my_text_field.dart';
import 'package:todolist/shared/values/media_values.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';

/// TaskCreate is a widget for creating a new task.
/// It includes fields for task name, reminder, and deadline.
class TaskCreate extends StatefulWidget {
  /// The presenter responsible for handling business logic related to tasks.
  final TaskPresenterContract _presenter;

  /// Constructor for [TaskCreate].
  ///
  /// Requires a [TaskPresenterContract] to handle task creation.
  const TaskCreate({super.key, required TaskPresenterContract presenter})
    : _presenter = presenter;

  @override
  State<TaskCreate> createState() => _TaskCreateState();
}

class _TaskCreateState extends State<TaskCreate> {
  /// Text controller for the task name input field.
  late final TextEditingController _controllerName;

  /// The selected reminder date and time.
  DateTime? _reminder;

  /// The formatted reminder date and time as a string.
  String? _formattedReminder;

  /// The selected deadline date and time.
  DateTime? _deadline;

  /// The formatted deadline date and time as a string.
  String? _formattedDeadline;

  @override
  void initState() {
    super.initState();
    _controllerName = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaValues(context).bottom,
          left: Screen.padding.left,
          right: Screen.padding.right,
          top: Screen.padding.top,
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: MyTextField(
                    controller: _controllerName,
                    labelText: 'Create Task',
                    hintText: 'Enter task name...',
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: ThemeValues(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    color: ThemeValues(context).colorScheme.onPrimary,
                    onPressed: () async {
                      await widget._presenter.createSingleTask(
                        Task(
                          name: _controllerName.text,
                          description: '',
                          order: null,
                          reminder: _reminder,
                          deadline: _deadline,
                        ),
                      );
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      side: WidgetStatePropertyAll(
                        BorderSide(
                          color:
                              _formattedReminder == null
                                  ? ThemeValues(context).colorScheme.onSurface
                                  : Colors.transparent,
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        _formattedReminder == null
                            ? Colors.transparent
                            : ThemeValues(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () async {
                      final dateTime = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(3000),
                      );
                      if (dateTime == null || !context.mounted) return;

                      final timeOfDay = await showTimePicker(
                        initialEntryMode: TimePickerEntryMode.dial,
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (timeOfDay == null) return;

                      setState(
                        () =>
                            _reminder = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              timeOfDay.hour,
                              timeOfDay.minute,
                            ),
                      );
                      String day = DateFormat.E().format(_reminder!);
                      String time = DateFormat.Hm().format(_reminder!);
                      _formattedReminder = '$day, $time';
                    },
                    child: Row(
                      children: [
                        _formattedReminder == null
                            ? Icon(
                              Icons.notifications_off_outlined,
                              color:
                                  _formattedReminder == null
                                      ? ThemeValues(
                                        context,
                                      ).colorScheme.onSurface
                                      : ThemeValues(
                                        context,
                                      ).colorScheme.onPrimary,
                            )
                            : Icon(
                              Icons.notifications_active_outlined,
                              color:
                                  _formattedReminder == null
                                      ? ThemeValues(
                                        context,
                                      ).colorScheme.onSurface
                                      : ThemeValues(
                                        context,
                                      ).colorScheme.onPrimary,
                            ),
                        const SizedBox(width: 10),
                        MyText(
                          'Remind Me',
                          weight: FontWeight.bold,
                          color:
                              _formattedReminder == null
                                  ? ThemeValues(context).colorScheme.onSurface
                                  : ThemeValues(context).colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    style: ButtonStyle(
                      side: WidgetStatePropertyAll(
                        BorderSide(
                          color: ThemeValues(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final dateTime = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(3000),
                      );
                      if (dateTime == null || !context.mounted) return;

                      final timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (timeOfDay == null) return;

                      setState(
                        () =>
                            _deadline = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              timeOfDay.hour,
                              timeOfDay.minute,
                            ),
                      );
                      String day = DateFormat.E().format(_deadline!);
                      String time = DateFormat.Hm().format(_deadline!);
                      _formattedDeadline = '$day, $time';
                    },
                    child: Row(
                      children: [
                        _formattedDeadline == null
                            ? Icon(
                              Icons.timer_off_outlined,
                              color:
                                  _formattedDeadline == null
                                      ? ThemeValues(
                                        context,
                                      ).colorScheme.onSurface
                                      : ThemeValues(
                                        context,
                                      ).colorScheme.onPrimary,
                            )
                            : Icon(
                              Icons.timer_outlined,
                              color:
                                  _formattedDeadline == null
                                      ? ThemeValues(
                                        context,
                                      ).colorScheme.onSurface
                                      : ThemeValues(
                                        context,
                                      ).colorScheme.onPrimary,
                            ),
                        const SizedBox(width: 10),
                        MyText(
                          'Deadline',
                          color:
                              _formattedDeadline == null
                                  ? ThemeValues(context).colorScheme.onSurface
                                  : ThemeValues(context).colorScheme.onPrimary,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
