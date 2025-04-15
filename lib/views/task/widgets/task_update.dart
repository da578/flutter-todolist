import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/shared/components/my_app_bar.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/media_values.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';

class TaskUpdate extends StatefulWidget {
  final Task initialTask;
  final TaskPresenterContract presenter;

  const TaskUpdate({
    super.key,
    required this.initialTask,
    required this.presenter,
  });

  @override
  State<TaskUpdate> createState() => _TaskUpdateState();
}

class _TaskUpdateState extends State<TaskUpdate> {
  late final TextEditingController controllerName;
  late final TextEditingController controllerDescription;
  DateTime? reminder;
  String? formattedReminder;
  DateTime? deadline;
  String? formattedDeadline;

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController();
    controllerDescription = TextEditingController();

    final task = widget.initialTask;
    controllerName.text = task.name;
    controllerDescription.text = task.description;

    if (task.reminder == null) {
      reminder = null;
      formattedReminder = null;
    } else {
      reminder = task.reminder;
      formattedReminder =
          '${DateFormat.E().format(task.reminder!)}, ${DateFormat.Hm().format(task.reminder!)}';
    }

    if (task.deadline == null) {
      deadline = null;
      formattedDeadline = null;
    } else {
      deadline = task.deadline;
      formattedDeadline =
          '${DateFormat.E().format(task.deadline!)}, ${DateFormat.Hm().format(task.deadline!)}';
    }
  }

  @override
  void dispose() {
    super.dispose();
    controllerName.dispose();
    controllerDescription.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Detail Task'),
      body: SingleChildScrollView(
        child: Container(
          width: MediaValues(context).width,
          padding: Screen.padding.all,
          child: Column(
            children: [
              TextField(
                controller: controllerName,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  color: ThemeValues(context).colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter task name...',
                  fillColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () async {
                  final dateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1000),
                  );

                  if (dateTime == null) return;
                  if (!context.mounted) return;

                  final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (timeOfDay == null) return;

                  setState(
                    () =>
                        reminder = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          timeOfDay.hour,
                          timeOfDay.minute,
                        ),
                  );

                  String day = DateFormat.E().format(reminder!);
                  String time = DateFormat.Hm().format(reminder!);
                  formattedReminder = '$day, $time';
                },
                child: Ink(
                  width: MediaValues(context).width,
                  child: Row(
                    children: [
                      Icon(
                        widget.initialTask.reminder == null
                            ? Icons.notifications_off_outlined
                            : Icons.notifications_active_outlined,
                        color: ThemeValues(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 15),
                      MyText(
                        'Reminder',
                        color: ThemeValues(context).colorScheme.onSurface,
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ThemeValues(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: MyText(
                          formattedReminder ?? 'Empty',
                          color: ThemeValues(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(
                    thickness: 1,
                    color: ThemeValues(context).colorScheme.onSurface,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  final dateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1000),
                  );

                  if (dateTime == null) return;
                  if (!context.mounted) return;

                  final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (timeOfDay == null) return;

                  setState(
                    () =>
                        deadline = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          timeOfDay.hour,
                          timeOfDay.minute,
                        ),
                  );

                  String day = DateFormat.E().format(deadline!);
                  String time = DateFormat.Hm().format(deadline!);
                  formattedDeadline = '$day, $time';
                },
                child: Ink(
                  width: MediaValues(context).width,
                  child: Row(
                    children: [
                      Icon(
                        widget.initialTask.deadline == null
                            ? Icons.timer_off_outlined
                            : Icons.timer_outlined,
                        color: ThemeValues(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 15),
                      MyText(
                        'Deadline',
                        color: ThemeValues(context).colorScheme.onSurface,
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ThemeValues(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: MyText(
                          formattedDeadline ?? 'Empty',
                          color: ThemeValues(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(
                    thickness: 1,
                    color: ThemeValues(context).colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(
                width: MediaValues(context).width,
                child: Row(
                  children: [
                    Icon(
                      Icons.article,
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: controllerDescription,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Enter task description (optional)',
                          border: InputBorder.none,
                          fillColor: Colors.transparent,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.save),
        onPressed: () async {
          await widget.presenter.updateTask(
            Task(
              id: widget.initialTask.id,
              name: controllerName.text,
              description: controllerDescription.text,
              order: widget.initialTask.order,
              reminder: reminder,
              deadline: deadline,
            ),
          );

          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }
}
