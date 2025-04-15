import 'package:todolist/models/task.dart';

abstract class TaskPresenterContract {
  Future<void> createSingleTask(Task task);
  Future<void> createMultipleTasks(List<Task> tasks);
  Future<void> readTasks();
  Future<Task?> readLastTask();
  Future<Task?> readTaskById(int id);
  Future<void> updateTask(Task task);
  Future<void> toggleTaskStatus(int id);
  Future<void> reorderTasks(int oldIndex, int newIndex);
  Future<void> deleteTask(int id);
  Future<void> exportData(String format);
  Future<void> importData(String format);
}
