import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../contracts/task_repository_contract.dart';
import '../models/task.dart';

/// Repository for performing CRUD operations on [Task] using Isar.
///
/// This class provides methods for initializing the database, reading, creating,
/// updating, and deleting task data. It ensures thread-safe operations using Isar's
/// transaction mechanisms.
class TaskRepository implements TaskRepositoryContract {
  static TaskRepository? _instance;
  static late final Isar _isar;

  /// Private constructor to enforce singleton pattern
  TaskRepository._();

  /// Returns the singleton instance of [TaskRepository].
  ///
  /// If no instance exists, it creates one and initialize it.
  factory TaskRepository() => _instance ??= TaskRepository._();

  /// Initializes the Isar database in the application documents directory.
  ///
  /// This method must be called before using any other repository methods.
  /// It opens the Isar database with the [TaskSchema] and sets up the storage location.
  @override
  Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([TaskSchema], directory: directory.path);
  }

  /// Adds a single task to the database.
  ///
  /// If the task ID is not specified, Isar will automatically assign one.
  /// Throws an exception if the task name is empty or contains only whitespace.
  @override
  Future<void> createSingleTask(Task task) async {
    if (task.name.trim().isEmpty) throw Exception('Task name must be filled!');
    await _isar.writeTxn(() => _isar.tasks.put(task));
  }

  /// Adds multiple tasks to the database at once.
  ///
  /// This method is useful for bulk insertion of tasks. It ensures all tasks are added
  /// in a single transaction for performance and consistency.
  @override
  Future<void> createMultipleTasks(List<Task> tasks) async =>
      await _isar.writeTxn(() => _isar.tasks.putAll(tasks));

  /// Retrieves all tasks stored in the database, sorted by their `order` field.
  ///
  /// Returns a list of tasks sorted in ascending order based on the `order` property.
  @override
  Future<List<Task>> readTasks() async =>
      _isar.tasks.where().sortByOrder().findAll();

  /// Retrieves the last task based on the `order` field.
  ///
  /// Returns null if no tasks are found in the database.
  @override
  Future<Task?> readLastTask() async {
    final tasks = await readTasks();
    return tasks.isEmpty ? null : tasks.last;
  }

  /// Retrieves a task by its unique ID.
  ///
  /// Returns null if no task with the specified ID exists in the database.
  @override
  Future<Task?> readTaskById(int id) => Future.value(_isar.tasks.get(id));

  /// Updates an existing task in the database.
  ///
  /// Checks for the existence of the task before performing the update.
  ///
  /// Throws an [Exception] if the task with the given ID is not found.
  @override
  Future<void> updateTask(Task task) async {
    final existingTask = await readTaskById(task.id);
    if (existingTask == null) {
      throw Exception('Task with ID ${task.id} not found');
    }
    task.updateTimestamp();
    await _isar.writeTxn(() => _isar.tasks.put(task));
  }

  /// Toggles the completion status of a task (completed/incomplete).
  ///
  /// Flips the boolean value of the `status` field for the task with the given ID.
  ///
  /// Throws an [Exception] if the task with the given ID is not found.
  @override
  Future<void> toggleTaskStatus(int id) async {
    final existingTask = await readTaskById(id);
    if (existingTask == null) {
      throw Exception('Task with ID $id not found');
    }
    existingTask.status = !existingTask.status;
    existingTask.updateTimestamp();
    await _isar.writeTxn(() => _isar.tasks.put(existingTask));
  }

  /// Reorders tasks based on the old and new indices.
  ///
  /// Ensures valid indices and updates the `order` field for all affected tasks.
  ///
  /// Throws an [Exception] if the provided indices are out of bounds.
  @override
  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    final tasks = await readTasks();

    if (oldIndex < 0 ||
        newIndex < 0 ||
        oldIndex >= tasks.length ||
        newIndex >= tasks.length) {
      throw ArgumentError(
        'Invalid indices: oldIndex=$oldIndex, newIndex=$newIndex',
      );
    }

    if (oldIndex == newIndex) return;

    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);

    for (int i = 0; i < tasks.length; i++) {
      tasks[i].order = i;
      tasks[i].updateTimestamp();
    }

    await _isar.writeTxn(() => _isar.tasks.putAll(tasks));
  }

  /// Deletes a task by its unique ID.
  ///
  /// Removes the task with the specified ID from the database.
  /// Throws an [Exception] if the task with the given ID is not found.
  @override
  Future<void> deleteTask(int id) async {
    final existingTask = await readTaskById(id);
    if (existingTask == null) {
      throw Exception('Task with ID $id not found');
    }
    await _isar.writeTxn(() => _isar.tasks.delete(id));
  }
}
