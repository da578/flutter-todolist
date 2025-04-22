import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/shared/components/my_alert_dialog.dart';
import 'package:todolist/shared/components/my_filled_button.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/task_values.dart';
import 'package:todolist/shared/values/theme_values.dart';
import 'package:todolist/views/task/widgets/task_update.dart';

/// TaskItem is a widget that represents a single task in the task list.
///
/// This widget provides functionality for interacting with tasks, such as marking them
/// as complete, updating them, or deleting them. It also supports animations and swipe
/// actions for better user experience.
class TaskItem extends StatefulWidget {
  /// The index of the task in the list.
  final int _index;

  /// The complete list of tasks.
  final List<Task> _tasks;

  /// The task represented by this widget.
  final Task _task;

  /// The presenter responsible for handling business logic related to tasks.
  final TaskPresenterContract _presenter;

  /// Constructor for [TaskItem].
  ///
  /// Parameters:
  /// - [index]: The position of the task in the list.
  /// - [tasks]: The complete list of tasks.
  /// - [task]: The task represented by this widget.
  /// - [presenter]: The task presenter for handling business logic.
  const TaskItem({
    super.key,
    required int index,
    required List<Task> tasks,
    required Task task,
    required TaskPresenterContract presenter,
  }) : _presenter = presenter,
       _task = task,
       _tasks = tasks,
       _index = index;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool get _hasReminderOrDeadline =>
      widget._task.reminder != null || widget._task.deadline != null;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildAnimatedTaskItem(context);

  /// Builds the animated task item with effects based on its state.
  ///
  /// The effects are determined by whether the task was recently created, updated, or deleted.
  Widget _buildAnimatedTaskItem(BuildContext context) {
    final effects = _getAnimationEffects(context);
    return Animate(
      effects: effects,
      delay: Duration(milliseconds: widget._index * 100),
      onComplete: (_) {
        if (widget._task.id == widget._tasks.last.id) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => TaskValues(context).read.reset(),
          );
        }
      },
      child: GestureDetector(
        onTap: () => _navigateToUpdateTaskScreen(context),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (_, _) => _buildTaskContent(),
        ),
      ),
    );
  }

  Widget _buildTaskContent() {
    final Animation<Color?> colorAnimation = ColorTween(
      begin: ThemeValues(context).colorScheme.primary,
      end: Colors.transparent,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Screen.curve));

    final Animation<double> sizeAnimation = Tween<double>(
      begin: 2,
      end: 0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Screen.curve));

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border:
            !widget._task.status
                ? Border.all(
                  color:
                      _hasReminderOrDeadline
                          ? colorAnimation.value!
                          : ThemeValues(context).colorScheme.primary,
                  width: _hasReminderOrDeadline ? sizeAnimation.value : 2,
                )
                : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(10),
        child: Slidable(
          startActionPane: _buildUpdateActionPane(context),
          endActionPane: _buildDeleteActionPane(context),
          child: _buildTaskContainer(context),
        ),
      ),
    );
  }

  /// Retrieves the animation effects for the task item based on its state.
  ///
  /// Effects are applied when the task is created, updated, or read from the list.
  List<Effect<dynamic>> _getAnimationEffects(BuildContext context) {
    final createdIds = TaskValues(context).watch.createdIds;
    final updatedIds = TaskValues(context).watch.updatedIds;

    if (createdIds.contains(widget._task.id)) {
      return [
        ScaleEffect(
          begin: Offset.zero,
          end: const Offset(1, 1),
          duration: Screen.duration,
        ),
      ];
    } else if (updatedIds.contains(widget._task.id)) {
      return [FadeEffect(begin: 0, end: 1, duration: Screen.duration)];
    } else {
      return [
        ScaleEffect(
          begin: Offset.zero,
          end: const Offset(1, 1),
          duration: Screen.duration,
        ),
        FadeEffect(begin: 0, end: 1, duration: Screen.duration),
      ];
    }
  }

  /// Builds the action pane for updating the task.
  ActionPane _buildUpdateActionPane(BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          backgroundColor:
              widget._task.status
                  ? Colors.amber
                  : ThemeValues(context).colorScheme.surfaceContainerHigh,
          foregroundColor: widget._task.status ? Colors.black : Colors.amber,
          icon: Icons.edit_outlined,
          label: 'Update',
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          onPressed: (_) => _navigateToUpdateTaskScreen(context),
        ),
      ],
    );
  }

  /// Builds the action pane for deleting the task.
  ActionPane _buildDeleteActionPane(BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          backgroundColor:
              widget._task.status
                  ? Colors.red
                  : ThemeValues(context).colorScheme.surfaceContainerHigh,
          foregroundColor: widget._task.status ? Colors.white : Colors.red,
          icon: Icons.delete_outline_rounded,
          label: 'Delete',
          onPressed: (_) => _showDeleteConfirmationDialog(context),
        ),
      ],
    );
  }

  /// Shows a confirmation dialog before deleting the task.
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
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
                        text: widget._task.name,
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
                  await widget._presenter.deleteTask(widget._task.id);
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

  /// Builds the container for displaying the task details.
  Widget _buildTaskContainer(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final Animation<Color?> backgroundColorAnimation = ColorTween(
          begin: ThemeValues(context).colorScheme.surfaceContainerHigh,
          end: _determineBackgroundColor(),
        ).animate(
          CurvedAnimation(parent: _pulseController, curve: Screen.curve),
        );

        final Animation<Color?> foregroundColorAnimation = ColorTween(
          begin: ThemeValues(context).colorScheme.onSurface,
          end: _determineForegroundColor(),
        ).animate(
          CurvedAnimation(parent: _pulseController, curve: Screen.curve),
        );

        return AnimatedContainer(
          duration: Screen.duration,
          padding: Screen.padding.all,
          decoration: BoxDecoration(
            color:
                _hasReminderOrDeadline
                    ? backgroundColorAnimation.value
                    : widget._task.status
                    ? ThemeValues(context).colorScheme.primary
                    : ThemeValues(context).colorScheme.surfaceContainerHigh,
          ),
          child: Row(
            children: [
              Checkbox(
                shape: const CircleBorder(),
                activeColor:
                    _hasReminderOrDeadline
                        ? foregroundColorAnimation.value!
                        : ThemeValues(context).colorScheme.onPrimary,
                checkColor:
                    _hasReminderOrDeadline
                        ? backgroundColorAnimation.value!
                        : ThemeValues(context).colorScheme.primary,
                side: BorderSide(
                  color:
                      _hasReminderOrDeadline
                          ? foregroundColorAnimation.value!
                          : ThemeValues(context).colorScheme.onSurface,
                  width: 2,
                ),
                value: widget._task.status,
                onChanged:
                    (_) async => await widget._presenter.toggleTaskStatus(
                      widget._task.id,
                    ),
              ),
              const SizedBox(width: 5),
              MyText(
                widget._task.name,
                color:
                    _hasReminderOrDeadline
                        ? foregroundColorAnimation.value
                        : widget._task.status
                        ? ThemeValues(context).colorScheme.onPrimary
                        : ThemeValues(context).colorScheme.onSurface,
                weight: FontWeight.w500,
                isLineThrough: widget._task.status,
                decorationColor: ThemeValues(context).colorScheme.onPrimary,
              ),
              const Spacer(),
              const SizedBox(width: 10),
              ReorderableDragStartListener(
                index: widget._index,
                child: Icon(
                  Icons.menu,
                  color:
                      _hasReminderOrDeadline
                          ? foregroundColorAnimation.value
                          : widget._task.status
                          ? ThemeValues(context).colorScheme.onPrimary
                          : ThemeValues(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Navigates to the update task screen with a fade and slide transition.
  void _navigateToUpdateTaskScreen(BuildContext context) {
    TaskValues(context).read.setIsUpdating(true);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (_, __, ___) => TaskUpdate(
              initialTask: widget._task,
              presenter: widget._presenter,
            ),
        transitionsBuilder:
            (_, animation, ___, child) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: animation.drive(
                  Tween(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Screen.curve)),
                ),
                child: child,
              ),
            ),
        transitionDuration: Screen.duration,
      ),
    ).then((_) {
      if (context.mounted) TaskValues(context).read.setIsUpdating(false);
    });
  }

  Color _determineBackgroundColor() {
    if (widget._task.deadline != null) return Colors.red;
    if (widget._task.reminder != null) {
      return ThemeValues(context).colorScheme.primary;
    }
    return ThemeValues(context).colorScheme.surfaceContainerHigh;
  }

  Color _determineForegroundColor() {
    if (widget._task.deadline != null) return Colors.white;
    if (widget._task.reminder != null) {
      return ThemeValues(context).colorScheme.onPrimary;
    }
    return ThemeValues(context).colorScheme.onSurface;
  }
}
