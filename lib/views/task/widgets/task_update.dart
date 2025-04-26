import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/shared/components/my_alert_dialog.dart';
import 'package:todolist/shared/components/my_app_bar.dart';
import 'package:todolist/shared/components/my_filled_button.dart';
import 'package:todolist/shared/components/my_sized_box.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/media_values.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';

/// A widget for updating a task's details
///
/// This widget allow users to edit the name, description, reminder, and deadline
/// of a task. It also provides options to mark the task as done or delete it
class TaskUpdate extends StatefulWidget {
  /// The initial task data to be updated
  final Task _initialTask;

  /// The presenter responsible for handling business logic related to tasks.
  final TaskPresenterContract _presenter;

  /// Constructor for [TaskUpdate]
  ///
  /// Parameters
  /// - [initialTask]: The task to be updated.
  /// - [presenter]: The task presenter for handling updates.
  const TaskUpdate({
    super.key,
    required Task initialTask,
    required TaskPresenterContract presenter,
  }) : _initialTask = initialTask,
       _presenter = presenter;

  @override
  State<TaskUpdate> createState() => _TaskUpdateState();
}

class _TaskUpdateState extends State<TaskUpdate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  /// Controller for the task name input field.
  late final TextEditingController _controllerName;

  /// Controller for the task description input field.
  late final TextEditingController _controllerDescription;

  /// The selected reminder date and time.
  DateTime? reminder;

  /// The formatted reminder date and time for display.
  String? formattedReminder;

  /// The selected deadline date and time.
  DateTime? deadline;

  /// The formatted deadline date and time for display.
  String? formattedDeadline;

  @override
  void initState() {
    super.initState();

    // initialize animation controllers
    _animationController = AnimationController(
      vsync: this,
      duration: Screen.duration,
    );

    // Initialize controllers and pre-fill with initial task data.
    final task = widget._initialTask;
    _controllerName = TextEditingController(text: task.name);
    _controllerDescription = TextEditingController(text: task.description);

    // Initialize reminder and deadline values.
    if (task.reminder != null) {
      reminder = task.reminder;
      formattedReminder =
          '${DateFormat.E().format(task.reminder!)}, ${DateFormat.Hm().format(task.reminder!)}';
    }
    if (task.deadline != null) {
      deadline = task.deadline;
      formattedDeadline =
          '${DateFormat.E().format(task.deadline!)}, ${DateFormat.Hm().format(task.deadline!)}';
    } else {}
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controllerName.dispose();
    _controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildScaffold();

  Widget _buildScaffold() => Scaffold(
    appBar: _buildAppBar(),
    body: _buildBody(),
    floatingActionButton: _buildFloatingActionButton(),
  );

  MyAppBar _buildAppBar() => MyAppBar(
    title: 'Detail Task',
    actions: [
      PopupMenuButton(
        icon: Icon(Icons.more_vert_rounded),
        iconColor: ThemeValues(context).colorScheme.onSurface,
        elevation: 1,
        borderRadius: BorderRadius.circular(20),
        itemBuilder:
            (_) => [
              PopupMenuItem(
                onTap:
                    () => setState(
                      () =>
                          widget._initialTask.status =
                              !widget._initialTask.status,
                    ),
                child: Row(
                  children: [
                    Icon(
                      widget._initialTask.status
                          ? Icons.close_rounded
                          : Icons.done_rounded,
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 10),
                    MyText(
                      widget._initialTask.status
                          ? 'Mark as unfinished'
                          : 'Mark as finished',
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  final task =
                      widget._initialTask
                        ..name = '${widget._initialTask.name} (Copy)'
                        ..onCreated = DateTime.now();
                  widget._presenter.createSingleTask(task);
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.file_copy_outlined,
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 10),
                    MyText(
                      'Duplicate',
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  SharePlus.instance.share(ShareParams(text: 'Hello, World!'));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.share_rounded,
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 10),
                    MyText(
                      'Share',
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  await _showDeleteConfirmationDialog(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 10),
                    MyText(
                      'Delete',
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ],
      ),
    ],
  );

  Widget _buildBody() => SingleChildScrollView(
    child: Container(
      width: MediaValues(context).width,
      padding: Screen.padding.all,
      child: Column(
        children: [
          _buildTaskName(),
          const SizedBox(height: 15),
          _buildReminderSelector(),
          _buildDivider(),
          _buildDeadlineSelector(),
          _buildDivider(),
          _buildTaskDescription(),
        ],
      ),
    ),
  );

  Widget _buildTaskName() => Row(
    children: [
      AnimatedContainer(
        duration: Screen.duration,
        curve: Screen.curve,
        child:
            widget._initialTask.status
                ? Icon(
                  Icons.done_rounded,
                  color: ThemeValues(context).colorScheme.primary,
                )
                : Icon(
                  Icons.close_rounded,
                  color: ThemeValues(context).colorScheme.error,
                ),
      ),
      Expanded(
        child: TextField(
          controller: _controllerName,
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
      ),
    ],
  );

  Widget _buildFloatingActionButton() => FloatingActionButton(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    onPressed: _saveTask,
    child: const Icon(Icons.save),
  );

  Widget _buildDivider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Opacity(
      opacity: 0.5,
      child: Divider(
        thickness: 1,
        color: ThemeValues(context).colorScheme.onSurface,
      ),
    ),
  );

  Widget _buildReminderSelector() => InkWell(
    onTap: _selectReminder,
    child: Ink(
      width: MediaValues(context).width,
      child: Row(
        children: [
          Icon(
            widget._initialTask.reminder == null
                ? Icons.notifications_off_outlined
                : Icons.notifications_active_outlined,
            color: ThemeValues(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 15),
          MyText('Reminder', color: ThemeValues(context).colorScheme.onSurface),
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
          reminder != null ? const SizedBox(width: 10) : MySizedBox.empty,
          reminder != null
              ? IconButton(
                onPressed: () {
                  setState(() {
                    reminder = null;
                    formattedReminder = null;
                  });
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: ThemeValues(context).colorScheme.onSurface,
                ),
              )
              : MySizedBox.empty,
        ],
      ),
    ),
  );

  Widget _buildDeadlineSelector() => InkWell(
    onTap: _selectDeadline,
    child: Ink(
      width: MediaValues(context).width,
      child: Row(
        children: [
          Icon(
            widget._initialTask.deadline == null
                ? Icons.timer_off_outlined
                : Icons.timer_outlined,
            color: ThemeValues(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 15),
          MyText('Deadline', color: ThemeValues(context).colorScheme.onSurface),
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
          deadline != null ? const SizedBox(width: 10) : MySizedBox.empty,
          deadline != null
              ? IconButton(
                onPressed: () {
                  setState(() {
                    deadline = null;
                    formattedDeadline = null;
                  });
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: ThemeValues(context).colorScheme.onSurface,
                ),
              )
              : MySizedBox.empty,
        ],
      ),
    ),
  );

  Widget _buildTaskDescription() => SizedBox(
    width: MediaValues(context).width,
    child: Row(
      children: [
        Icon(Icons.article, color: ThemeValues(context).colorScheme.onSurface),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            controller: _controllerDescription,
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
  );

  /// Opens a date and time picker to select a reminder.
  Future<void> _selectReminder() async {
    final dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1000),
    );
    if (dateTime == null || !mounted) return;

    if (mounted) {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (timeOfDay == null) return;

      setState(() {
        reminder = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );
        formattedReminder =
            '${DateFormat.E().format(reminder!)}, ${DateFormat.Hm().format(reminder!)}';
      });
    }
  }

  /// Opens a date and time picker to select a deadline.
  Future<void> _selectDeadline() async {
    final dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1000),
    );
    if (dateTime == null || !context.mounted) return;

    if (mounted) {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (timeOfDay == null) return;

      setState(() {
        deadline = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );
        formattedDeadline =
            '${DateFormat.E().format(deadline!)}, ${DateFormat.Hm().format(deadline!)}';
      });
    }
  }

  /// Shows a confirmation dialog before deleting the task.
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder:
          (_) => MyAlertDialog(
            title: 'Confirmation',
            content: Column(
              children: [
                Lottie.asset('lib/assets/animations/delete.json', height: 125),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      height: 1.5,
                      color: ThemeValues(context).colorScheme.onSurface,
                    ),
                    children: [
                      const TextSpan(text: 'Are you sure want to delete '),
                      TextSpan(
                        text: widget._initialTask.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' task?'),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              MyFilledButton(
                backgroundColor: WidgetStatePropertyAll(
                  ThemeValues(context).colorScheme.error,
                ),
                onPressed: () => Navigator.pop(context),
                child: MyText(
                  'No',
                  color: ThemeValues(context).colorScheme.onError,
                ),
              ),
              MyFilledButton(
                backgroundColor: WidgetStatePropertyAll(
                  ThemeValues(context).colorScheme.primary,
                ),
                onPressed: () async {
                  await widget._presenter.deleteTask(widget._initialTask.id);
                  if (context.mounted) Navigator.pop(context);
                },
                child: MyText(
                  'Yes',
                  color: ThemeValues(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
    );
  }

  /// Saves the updated task and navigates back to the previous screen.
  Future<void> _saveTask() async {
    await widget._presenter.updateTask(
      Task(
        id: widget._initialTask.id,
        name: _controllerName.text,
        description: _controllerDescription.text,
        status: widget._initialTask.status,
        order: widget._initialTask.order,
        reminder: reminder,
        deadline: deadline,
      ),
    );
    if (mounted) Navigator.pop(context);
  }
}
