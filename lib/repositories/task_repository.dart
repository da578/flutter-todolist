import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../contracts/task_repository_contract.dart';
import '../models/task.dart';

/// Repository for CRUD operations on Task using Isar.
///
/// This class provides methods for initializing the database, reading, creating,
/// updating, and deleting task data.
class TaskRepository implements TaskRepositoryContract {
  static TaskRepository? _instance;
  static late final Isar _isar;

  TaskRepository._();

  /// Returns the singleton instance of [TaskRepository].
  factory TaskRepository() => _instance ??= TaskRepository._();

  /// Initializes the Isar database in the application documents directory.
  ///
  /// Must be called before using any other methods.
  @override
  Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([TaskSchema], directory: directory.path);
  }

  /// Adds a single task to the database.
  ///
  /// If the task ID is not specified, Isar will automatically assign one.
  @override
  Future<void> createSingleTask(Task task) async {
    if (task.name.trim().isEmpty) throw Exception('Task name must be filled!');
    await _isar.writeTxn(() => _isar.tasks.put(task));
  }

  /// Adds multiple tasks to the database at once.
  @override
  Future<void> createMultipleTasks(List<Task> tasks) async =>
      await _isar.writeTxn(() => _isar.tasks.putAll(tasks));

  /// Retrieves all tasks stored in the database, sorted by order.
  ///
  /// Returns a list of tasks sorted by the `order` field.
  @override
  Future<List<Task>> readTasks() async =>
      _isar.tasks.where().sortByOrder().findAll();

  /// Retrieves the last task based on the order.
  ///
  /// Returns null if no tasks are found.
  @override
  Future<Task?> readLastTask() async {
    final tasks = await readTasks();
    return tasks.isEmpty ? null : tasks.last;
  }

  /// Retrieves a task by its ID.
  ///
  /// Returns null if the task is not found.
  @override
  Future<Task?> readTaskById(int id) => Future.value(_isar.tasks.get(id));

  /// Updates an existing task in the database.
  ///
  /// Checks for the existence of the task before performing the update.
  ///
  /// Throws an [Exception] if the task is not found.
  @override
  Future<void> updateTask(Task task) async {
    final existingTask = await readTaskById(task.id);
    if (existingTask == null) {
      throw Exception('Task with ID ${task.id} not found');
    }
    await _isar.writeTxn(() => _isar.tasks.put(task));
  }

  /// Toggles the status of a task (completed/incomplete) by changing the boolean value.
  ///
  /// Throws an [Exception] if the task is not found.
  @override
  Future<void> toggleTaskStatus(int id) async {
    final existingTask = await readTaskById(id);
    if (existingTask == null) {
      throw Exception('Task with ID $id not found');
    }
    existingTask.status = !existingTask.status;
    await _isar.writeTxn(() => _isar.tasks.put(existingTask));
  }

  /// Reorders tasks based on the old and new indices.
  ///
  /// Ensures valid indices and updates the order of all tasks.
  ///
  /// Throws an [ArgumentError] if indices are invalid.
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
    }

    await _isar.writeTxn(() => _isar.tasks.putAll(tasks));
  }

  /// Deletes a task by its ID.
  ///
  /// Throws an [Exception] if the task is not found.
  @override
  Future<void> deleteTask(int id) async {
    final existingTask = await readTaskById(id);
    if (existingTask == null) {
      throw Exception('Task with ID $id not found');
    }
    await _isar.writeTxn(() => _isar.tasks.delete(id));
  }
}
