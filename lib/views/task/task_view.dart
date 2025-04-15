import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/contracts/task_view_contract.dart';
import 'package:todolist/presenters/task_presenter.dart';
import 'package:todolist/providers/task_provider.dart';
import 'package:todolist/repositories/task_repository.dart';
import 'package:todolist/shared/values/task_values.dart';
import 'package:todolist/views/task/widgets/task_app_bar.dart';
import 'package:todolist/views/task/widgets/task_item.dart';
import '../../models/task.dart';
import '../../shared/components/my_text.dart';
import '../../shared/values/screen.dart';
import '../../shared/values/theme_values.dart';

/// TaskView is the main screen for managing tasks.
/// It displays a list of tasks with filtering, reordering, and pull-to-refresh functionality.
class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView>
    with SingleTickerProviderStateMixin
    implements TaskViewContract {
  late final TaskPresenterContract _presenter;
  late final AnimationController _animationController;

  /// Initialize the state for the animation controller and task presenter.
  ///
  /// The [AnimationController] is used for UI animations.
  /// The [TaskPresenter] handles business logic and interacts with the repository and provider.
  @override
  void initState() {
    super.initState();

    // Initialize the presenter with required dependencies.
    _presenter = TaskPresenter(
      repository: TaskRepository(),
      provider: Provider.of<TaskProvider>(context, listen: false),
      view: this,
    );

    // Initialize the animation controller for UI transitions.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Fetch tasks after the widget is fully built.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await _presenter.readTasks(),
    );
  }

  /// Dispose of resources to prevent memory leaks.
  ///
  /// The [AnimationController] must be disposed when the widget is removed from the tree.
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Show an error message using the FlutterToast package.
  ///
  /// This method is called by the presenter when an error occurs.
  @override
  void showError(String message) {
    if (mounted) {
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: ThemeValues(context).colorScheme.error,
        textColor: ThemeValues(context).colorScheme.onError,
      );
    }
  }

  /// Filter tasks based on the search query.
  ///
  /// If the search query is empty, return all tasks.
  /// Otherwise, return tasks whose names contain the search query (case-insensitive).
  List<Task> filteredTasksFunction(List<Task> tasks) =>
      TaskValues(context).watch.searchQuery.isEmpty
          ? tasks
          : tasks
              .where(
                (task) => task.name.toLowerCase().contains(
                  TaskValues(context).watch.searchQuery,
                ),
              )
              .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(
        animationController: _animationController,
        presenter: _presenter,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final tasks = provider.tasks;
          final filteredTasks = filteredTasksFunction(tasks);

          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ThemeValues(context).colorScheme.secondary,
              ),
            );
          }

          if (tasks.isEmpty) {
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.do_disturb_alt_outlined,
                    color: ThemeValues(context).colorScheme.onSurface,
                  ),
                  SizedBox(height: 10),
                  MyText(
                    'No tasks available.',
                    color: ThemeValues(context).colorScheme.onSurface,
                  ),
                ],
              ),
            );
          }

          return LiquidPullToRefresh(
            onRefresh: () async => await _presenter.readTasks(),
            color: ThemeValues(context).colorScheme.secondary,
            backgroundColor: ThemeValues(context).colorScheme.onSecondary,
            height: 125,
            showChildOpacityTransition: false,
            animSpeedFactor: 2,
            child: Padding(
              padding: Screen.padding.all,
              child: Column(
                children: [
                  Expanded(
                    child:
                        filteredTasks.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    color:
                                        ThemeValues(
                                          context,
                                        ).colorScheme.onSurface,
                                  ),
                                  const SizedBox(height: 10),
                                  MyText(
                                    'No tasks found.',
                                    color:
                                        ThemeValues(
                                          context,
                                        ).colorScheme.onSurface,
                                  ),
                                ],
                              ),
                            )
                            : ReorderableListView.builder(
                              buildDefaultDragHandles: false,
                              itemCount: filteredTasks.length,
                              itemBuilder:
                                  (context, index) => TaskItem(
                                    key: ValueKey(index),
                                    index: index,
                                    tasks: tasks,
                                    animationController: _animationController,
                                    task: filteredTasks[index],
                                    presenter: _presenter,
                                  ),
                              onReorder: (oldIndex, newIndex) async {
                                if (oldIndex < newIndex) newIndex -= 1;
                                await _presenter.reorderTasks(
                                  oldIndex,
                                  newIndex,
                                );
                              },
                              proxyDecorator:
                                  (child, _, _) => Material(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: child,
                                  ),
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
