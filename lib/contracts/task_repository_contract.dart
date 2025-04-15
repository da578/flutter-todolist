import '../models/task.dart';

abstract class TaskRepositoryContract {
  Future<void> initialize();
  Future<void> createSingleTask(Task task);
  Future<void> createMultipleTasks(List<Task> tasks);
  Future<List<Task>> readTasks();
  Future<Task?> readLastTask();
  Future<Task?> readTaskById(int id);
  Future<void> updateTask(Task task);
  Future<void> toggleTaskStatus(int id);
  Future<void> reorderTasks(int oldIndex, int newIndex);
  Future<void> deleteTask(int id);
}