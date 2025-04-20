import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
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
  /// - [animationController]: The controller for animations.
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

class _TaskItemState extends State<TaskItem> {
  Artboard? _artboard;

  @override
  void initState() {
    rootBundle.load('lib/assets/animations/confetti.riv').then((data) async {
      try {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        final controller = StateMachineController.fromArtboard(
          artboard,
          'bruh',
        );
      } catch (e) {
        print(e);
      }
    });
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
        child: AnimatedContainer(
          duration: Screen.duration,
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            border:
                !widget._task.status
                    ? Border.all(
                      color: ThemeValues(context).colorScheme.primary,
                      width: 2,
                    )
                    : null,
            borderRadius: BorderRadius.circular(10),
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
          foregroundColor:
              widget._task.status
                  ? Colors.white
                  : ThemeValues(context).colorScheme.onSurface,
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
    return Stack(
      children: [
        AnimatedContainer(
          padding: Screen.padding.all,
          duration: Screen.duration,
          curve: Screen.curve,
          decoration: BoxDecoration(
            color:
                widget._task.status
                    ? ThemeValues(context).colorScheme.primary
                    : ThemeValues(context).colorScheme.surfaceContainerHigh,
          ),
          child: Row(
            children: [
              Checkbox(
                shape: const CircleBorder(),
                activeColor: ThemeValues(context).colorScheme.onPrimary,
                checkColor: ThemeValues(context).colorScheme.primary,
                side: BorderSide(
                  color: ThemeValues(context).colorScheme.onSurface,
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
                    widget._task.status
                        ? ThemeValues(context).colorScheme.onPrimary
                        : ThemeValues(context).colorScheme.onSurface,
                weight: FontWeight.w500,
                isLineThrough: widget._task.status,
                decorationColor: ThemeValues(context).colorScheme.onPrimary,
              ),
              const Spacer(),
              ReorderableDragStartListener(
                index: widget._index,
                child: Icon(
                  Icons.menu,
                  color:
                      widget._task.status
                          ? ThemeValues(context).colorScheme.onPrimary
                          : ThemeValues(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        // widget._task.status
        //     ? Positioned(
        //       top: 0,
        //       right: 0,
        //       child: SizedBox(
        //         width: 100, // Atur lebar sesuai kebutuhan
        //         height: 100, // Atur tinggi sesuai kebutuhan
        //         child: RiveAnimation.asset(
        //           'lib/assets/animations/confetti.riv',
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     )
        //     : SizedBox.shrink(),
      ],
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
                  ).chain(CurveTween(curve: Curves.easeInOut)),
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
}
