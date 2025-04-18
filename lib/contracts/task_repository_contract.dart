import '../models/task.dart';

/// Abstract contract defining the interface for a [TaskRepository].
///
/// This contract ensures that any class implementing it provides methods for
/// performing CRUD operations on [Task] objects. It serves as a blueprint for
/// repositories that interact with task data storage (e.g., databases).
abstract class TaskRepositoryContract {
  /// Initializes the repository and sets up the necessary resources.
  ///
  /// This method must be called before using any other repository methods.
  /// It is responsible for preparing the storage mechanism (e.g., opening a database).
  Future<void> initialize();

  /// Adds a single task to the repository.
  ///
  /// If the task ID is not specified, the repository should automatically assign one.
  ///
  /// Throws an exception if the task name is empty or contains only whitespace.
  Future<void> createSingleTask(Task task);

  /// Adds multiple tasks to the repository at once.
  ///
  /// This method is useful for bulk insertion of tasks. It ensures all tasks are added
  /// in a single operation for performance and consistency.
  Future<void> createMultipleTasks(List<Task> tasks);

  /// Retrieves all tasks stored in the repository, sorted by their `order` field.
  ///
  /// Returns a list of tasks sorted in ascending order based on the `order` property.
  Future<List<Task>> readTasks();

  /// Retrieves the last task based on the `order` field.
  ///
  /// Returns null if no tasks are found in the repository.
  Future<Task?> readLastTask();

  /// Retrieves a task by its unique ID.
  ///
  /// Returns null if no task with the specified ID exists in the repository.
  Future<Task?> readTaskById(int id);

  /// Updates an existing task in the repository.
  ///
  /// Checks for the existence of the task before performing the update.
  ///
  /// Throws an [Exception] if the task with the given ID is not found.
  Future<void> updateTask(Task task);

  /// Toggles the completion status of a task (completed/incomplete).
  ///
  /// Flips the boolean value of the `status` field for the task with the given ID.
  ///
  /// Throws an [Exception] if the task with the given ID is not found.
  Future<void> toggleTaskStatus(int id);

  /// Reorders tasks based on the old and new indices.
  ///
  /// Ensures valid indices and updates the `order` field for all affected tasks.
  ///
  /// Throws an [Exception] if the provided indices are out of bounds.
  Future<void> reorderTasks(int oldIndex, int newIndex);

  /// Sorts tasks based on the specified sorting option.
  ///
  /// Supported options:
  /// - `ascending`: Sorts tasks by name in ascending order.
  /// - `descending`: Sorts tasks by name in descending order.
  /// - `nearest_deadline`: Sorts tasks by nearest deadline.
  /// - `farthest_deadline`: Sorts tasks by farthest deadline.
  /// - `nearest_reminder`: Sorts tasks by nearest reminder.
  /// - `farthest_reminder`: Sorts tasks by farthest reminder.
  /// - `completed_first`: Sorts tasks by completion status (completed first).
  /// - `newest_first`: Sorts tasks by creation date (newest first).
  /// - `oldest_first`: Sorts tasks by creation date (oldest first).
  ///
  /// Throws an [Exception] if the provided option is invalid.
  Future<List<Task>> sortTasks(String option);

  /// Deletes a task by its unique ID.
  ///
  /// Removes the task with the specified ID from the repository.
  ///
  /// Throws an [Exception] if the task with the given ID is not found.
  Future<void> deleteTask(int id);
}
