import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/shared/components/my_alert_dialog.dart';
import 'package:todolist/shared/components/my_filled_button.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/task_values.dart';
import 'package:todolist/shared/values/theme_values.dart';
import 'package:todolist/views/task/widgets/task_update.dart';

class TaskItem extends StatelessWidget {
  final int index;
  final List<Task> tasks;
  final AnimationController animationController;
  final Task task;
  final TaskPresenterContract presenter;

  const TaskItem({
    super.key,
    required this.index,
    required this.tasks,
    required this.animationController,
    required this.task,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    List<Effect<dynamic>> createEffect = [
      ScaleEffect(
        begin: Offset.zero,
        end: Offset(1, 1),
        duration: Screen.duration,
      ),
    ];

    List<Effect<dynamic>> readEffect = [
      ScaleEffect(
        begin: Offset.zero,
        end: Offset(1, 1),
        duration: Screen.duration,
      ),
      FadeEffect(begin: 0, end: 1, duration: Screen.duration),
    ];

    List<Effect<dynamic>> updateEffect = [
      FadeEffect(begin: 0, end: 1, duration: Screen.duration),
    ];

    List<Effect<dynamic>>? effects = [];

    if (TaskValues(context).watch.createdIds.isEmpty &&
        TaskValues(context).watch.updatedIds.isEmpty &&
        TaskValues(context).watch.deletedIds.isEmpty) {
      effects = readEffect;
    }

    if (TaskValues(context).read.createdIds.contains(task.id)) {
      effects = createEffect;
    }
    if (TaskValues(context).read.updatedIds.contains(task.id)) {
      effects = updateEffect;
    }

    return Animate(
      effects: effects,
      delay: Duration(milliseconds: index * 100),
      onComplete: (_) {
        if (task.id == tasks.last.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            effects = [];
            TaskValues(context).read.reset();
          });
        }
      },
      child: GestureDetector(
        onTap:
            () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (_, _, _) =>
                        TaskUpdate(initialTask: task, presenter: presenter),
                transitionsBuilder:
                    (_, animation, _, child) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation.drive(
                          Tween(
                            begin: Offset(0, 1),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeInOut)),
                        ),
                        child: child,
                      ),
                    ),
                transitionDuration: Screen.duration,
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.amber,
                    icon: Icons.edit_outlined,
                    label: 'Update',
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    onPressed:
                        (_) => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (_, _, _) => TaskUpdate(
                                  initialTask: task,
                                  presenter: presenter,
                                ),
                            transitionsBuilder:
                                (_, animation, _, child) => FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: animation.drive(
                                      Tween(
                                        begin: Offset(0, 1),
                                        end: Offset.zero,
                                      ).chain(
                                        CurveTween(curve: Curves.easeInOut),
                                      ),
                                    ),
                                    child: child,
                                  ),
                                ),
                            transitionDuration: Screen.duration,
                          ),
                        ),
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.red,
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete',
                    onPressed: (_) async {
                      showDialog(
                        context: context,
                        builder:
                            (_) => MyAlertDialog(
                              title: 'Confirmation',
                              content: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    height: 1.5,
                                    color:
                                        ThemeValues(
                                          context,
                                        ).colorScheme.onSurface,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Are you sure want to delete ',
                                    ),
                                    TextSpan(
                                      text: task.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: ' task?'),
                                  ],
                                ),
                              ),
                              actions: [
                                MyFilledButton(
                                  backgroundColor: WidgetStatePropertyAll(
                                    ThemeValues(context).colorScheme.error,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: MyText(
                                    'No',
                                    color:
                                        ThemeValues(
                                          context,
                                        ).colorScheme.onError,
                                  ),
                                ),
                                MyFilledButton(
                                  backgroundColor: WidgetStatePropertyAll(
                                    ThemeValues(context).colorScheme.primary,
                                  ),
                                  onPressed: () async {
                                    await presenter.deleteTask(task.id);
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                  child: MyText(
                                    'Yes',
                                    color:
                                        ThemeValues(
                                          context,
                                        ).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ),
              child: AnimatedContainer(
                padding: Screen.padding.all,
                duration: Screen.duration,
                curve: Screen.curve,
                decoration: BoxDecoration(
                  color:
                      task.status
                          ? Colors.green[500]
                          : ThemeValues(context).colorScheme.primary,
                ),
                child: Row(
                  children: [
                    Checkbox(
                      shape: CircleBorder(),
                      activeColor: Colors.white,
                      checkColor: Colors.green[500],
                      side: BorderSide(
                        color: ThemeValues(context).colorScheme.onPrimary,
                        width: 2,
                      ),
                      value: task.status,
                      onChanged:
                          (_) async =>
                              await presenter.toggleTaskStatus(task.id),
                    ),
                    const SizedBox(width: 5),
                    MyText(
                      task.name,
                      color:
                          task.status
                              ? Colors.white
                              : ThemeValues(context).colorScheme.onPrimary,
                      weight: FontWeight.w500,
                      isLineThrough: task.status ? true : false,
                      decorationColor: Colors.white,
                    ),
                    const Spacer(),
                    ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        Icons.menu,
                        color:
                            task.status
                                ? Colors.white
                                : ThemeValues(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
