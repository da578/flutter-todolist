import 'package:todolist/models/task.dart';

/// Abstract contract defining the interface for a [TaskPresenter].
///
/// This contract ensures that any class implementing it provides methods for
/// performing business logic related to tasks. It serves as a blueprint for
/// presenters that interact with task data and manage UI state.
abstract class TaskPresenterContract {
  /// Creates a single task and assigns the next available order number.
  ///
  /// The new task's order is determined based on the last task's order.
  /// If no tasks exist, the order starts at 0.
  ///
  /// Parameters:
  /// - [task]: The task to be created.
  ///
  /// Throws an error if task creation fails or if notification scheduling fails.
  Future<void> createSingleTask(Task task);

  /// Creates multiple tasks at once and schedules notifications for each task.
  ///
  /// This method performs the following steps:
  /// 1. Persists all tasks to the repository.
  /// 2. Schedules reminder and deadline notifications for each task if applicable.
  /// 3. Updates the provider with the newly created tasks.
  ///
  /// Parameters:
  /// - [tasks]: A list of tasks to be created.
  ///
  /// Throws an error if any task fails to save or if notification scheduling fails.
  Future<void> createMultipleTasks(List<Task> tasks);

  /// Fetches all tasks and updates the provider.
  ///
  /// This method is used to refresh the UI with the latest task list.
  ///
  /// Throws an error if fetching tasks fails.
  Future<void> readTasks();

  /// Retrieves the last task based on order.
  ///
  /// Returns null if no tasks exist.
  Future<Task?> readLastTask();

  /// Fetches a task by ID.
  ///
  /// Returns null if the task is not found.
  ///
  /// Parameters:
  /// - [id]: The ID of the task to fetch.
  Future<Task?> readTaskById(int id);

  /// Updates an existing task.
  ///
  /// This method performs the following steps:
  /// 1. Updates the task in the repository.
  /// 2. Reschedules reminder and deadline notifications if applicable.
  /// 3. Updates the provider with the updated task.
  ///
  /// Parameters:
  /// - [task]: The task to be updated.
  ///
  /// Throws an error if the task doesn't exist or if notification rescheduling fails.
  Future<void> updateTask(Task task);

  /// Toggles the status of a task (completed/incomplete).
  ///
  /// Automatically refreshes the UI after the status change.
  ///
  /// Parameters:
  /// - [id]: The ID of the task whose status is toggled.
  ///
  /// Throws an error if the task isn't found.
  Future<void> toggleTaskStatus(int id);

  /// Reorders tasks between two indices.
  ///
  /// Ensures valid indices and updates the provider with the reordered tasks.
  ///
  /// Parameters:
  /// - [oldIndex]: The original index of the task.
  /// - [newIndex]: The target index for the task.
  ///
  /// Throws an error if the indices are invalid.
  Future<void> reorderTasks(int oldIndex, int newIndex);

  /// Sorts tasks based on the specified option.
  ///
  /// Supported options include sorting by name, deadline, reminder, completion status,
  /// and creation date.
  ///
  /// Parameters:
  /// - [option]: The sorting criterion (e.g., 'ascending', 'descending').
  ///
  /// Throws an error if the sorting option is invalid.
  Future<void> sortTasks(String option);

  /// Deletes a task by ID.
  ///
  /// Updates the provider after successful deletion.
  ///
  /// Parameters:
  /// - [id]: The ID of the task to delete.
  ///
  /// Throws an error if the task isn't found.
  Future<void> deleteTask(int id);

  /// Exports tasks to a file in the specified format.
  ///
  /// Supported formats include JSON, YAML, and CSV.
  ///
  /// Parameters:
  /// - [format]: The format to export the tasks (e.g., 'JSON', 'YAML', 'CSV').
  ///
  /// Throws an error if the format is unsupported or if export fails.
  Future<void> exportData(String format);

  /// Imports tasks from a file in the specified format.
  ///
  /// Supported formats include JSON, YAML, and CSV.
  ///
  /// Parameters:
  /// - [format]: The format to import the tasks (e.g., 'JSON', 'YAML', 'CSV').
  ///
  /// Throws an error if the format is unsupported, if file selection fails,
  /// or if import fails.
  Future<void> importData(String format);
}
