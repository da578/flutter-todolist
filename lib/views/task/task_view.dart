import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/contracts/task_view_contract.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/presenters/task_presenter.dart';
import 'package:todolist/providers/task_provider.dart';
import 'package:todolist/repositories/task_repository.dart';
import 'package:todolist/shared/values/task_values.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';
import 'package:todolist/views/task/widgets/app_bar/task_app_bar.dart';
import 'package:todolist/views/task/widgets/task_item.dart';
import '../../shared/components/my_text.dart';

/// TaskView is the main screen for managing tasks.
///
/// This widget displays a list of tasks with filtering, reordering, and pull-to-refresh functionality.
/// It interacts with the [TaskPresenter] to handle business logic and state management.
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

  /// Initializes the state for the animation controller and task presenter.
  ///
  /// The [AnimationController] is used for UI animations.
  ///
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
      duration: Screen.duration,
    );

    // Fetch tasks after the widget is fully built.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await _presenter.readTasks(),
    );
  }

  /// Disposes of resources to prevent memory leaks.
  ///
  /// The [AnimationController] must be disposed when the widget is removed from the tree.
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Displays an error message using the FlutterToast package.
  ///
  /// This method is called by the presenter when an error occurs.
  ///
  /// Parameters:
  /// - [message]: The error message to display.
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

  @override
  Widget build(BuildContext context) {
    final taskValues = TaskValues(context).watch; // Use the TaskValues wrapper
    final filteredTasks = taskValues.filteredTasks; // Watch filtered tasks
    final tasks = taskValues.tasks; // Watch the full task list
    final isLoading = taskValues.isLoading; // Watch loading state
    final isCreating = taskValues.isCreating; // Watch is creating state
    final isUpdating = taskValues.isUpdating; // Watch is updating state
    final isExporting = taskValues.isExporting; // Watch is exporting state
    final isImporting = taskValues.isImporting; // Watch is importing state

    // Determine the top offset based on the current state
    double topOffset = 0;
    if (isCreating) topOffset = -50;
    if (isUpdating) topOffset = -150;
    if (isExporting || isImporting) topOffset = -75;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: Screen.duration,
          curve: Screen.curve,
          top: topOffset,
          bottom: 0,
          left: 0,
          right: 0,
          child: Scaffold(
            appBar: TaskAppBar(
              animationController: _animationController,
              presenter: _presenter,
            ),
            body: _buildBody(filteredTasks, tasks, isLoading),
          ),
        ),
      ],
    );
  }

  /// Builds the main body of the screen based on the current state.
  ///
  /// Parameters:
  /// - [filteredTasks]: The list of tasks filtered by the search query.
  /// - [tasks]: The complete list of tasks.
  /// - [isLoading]: Whether tasks are currently being loaded.
  Widget _buildBody(
    List<Task> filteredTasks,
    List<Task> tasks,
    bool isLoading,
  ) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: ThemeValues(context).colorScheme.secondary,
        ),
      );
    }

    if (tasks.isEmpty) return _buildEmptyState();

    return LiquidPullToRefresh(
      onRefresh: () async => await _presenter.readTasks(),
      color: ThemeValues(context).colorScheme.secondary,
      backgroundColor: ThemeValues(context).colorScheme.onPrimary,
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
                      ? _buildNoResultsState()
                      : ReorderableListView.builder(
                        buildDefaultDragHandles: false,
                        itemCount: filteredTasks.length,
                        itemBuilder:
                            (context, index) => TaskItem(
                              key: ValueKey(index),
                              index: index,
                              tasks: tasks,
                              task: filteredTasks[index],
                              presenter: _presenter,
                            ),
                        onReorder: (oldIndex, newIndex) async {
                          if (oldIndex < newIndex) newIndex -= 1;
                          await _presenter.reorderTasks(oldIndex, newIndex);
                        },
                        proxyDecorator:
                            (child, _, __) => Material(
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
  }

  /// Builds the empty state UI when no tasks are available.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.do_disturb_alt_outlined,
            color: ThemeValues(context).colorScheme.onSurface,
            size: 40,
          ),
          const SizedBox(height: 10),
          MyText(
            'No tasks available.',
            color: ThemeValues(context).colorScheme.onSurface,
            size: 20,
          ),
        ],
      ),
    );
  }

  /// Builds the no results state UI when no tasks match the search query.
  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: ThemeValues(context).colorScheme.onSurface,
            size: 40,
          ),
          const SizedBox(height: 10),
          MyText(
            'No tasks found.',
            color: ThemeValues(context).colorScheme.onSurface,
            size: 20,
          ),
        ],
      ),
    );
  }
}
