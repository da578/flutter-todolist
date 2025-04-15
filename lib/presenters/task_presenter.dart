import 'package:flutter/foundation.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/contracts/task_repository_contract.dart';
import 'package:todolist/contracts/task_view_contract.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/providers/task_provider.dart';
import 'package:todolist/services/notification_service.dart';
import 'package:todolist/services/task_export_service.dart';
import 'package:todolist/services/task_import_service.dart';

/// Presenter for task operations, acting as a bridge between repository and view.
///
/// This class handles business logic, error handling, and state management
/// through the provider. It ensures seamless interaction between the data layer
/// (repository) and the UI layer (view).
class TaskPresenter implements TaskPresenterContract {
  final TaskRepositoryContract _repository;
  final TaskProvider _provider;
  final TaskViewContract _view;

  TaskPresenter({
    required TaskRepositoryContract repository,
    required TaskProvider provider,
    required TaskViewContract view,
  }) : _repository = repository,
       _provider = provider,
       _view = view;

  final _exportService = TaskExportService();
  final _importService = TaskImportService();

  /// Creates a single task and assigns the next available order number.
  ///
  /// The new task's order is determined based on the last task's order.
  /// If no tasks exist, the order starts at 0.
  ///
  /// Parameters:
  /// - [task]: The task to be created.
  ///
  /// Throws an error if task creation fails or if notification scheduling fails.
  @override
  Future<void> createSingleTask(Task task) async {
    try {
      final lastTask = await _repository.readLastTask();
      final newTask = Task(
        name: task.name,
        description: task.description,
        order: (lastTask?.order ?? -1) + 1,
        reminder: task.reminder,
        deadline: task.deadline,
      );

      await _repository.createSingleTask(newTask);

      _provider
        ..setCreatedIds({newTask.id})
        ..setTasks(await _repository.readTasks());

      if (newTask.reminder != null) {
        await NotificationService.scheduleReminder(
          'reminder_${newTask.id}',
          newTask.reminder!,
          'Reminder: ${newTask.name}',
          'Your task is due soon!',
        );
      }

      if (newTask.deadline != null) {
        await NotificationService.scheduleDeadline(
          'deadline_${newTask.id}',
          newTask.deadline!,
          'Deadline: ${newTask.name}',
          'Your task is due!',
        );
      }
    } catch (e) {
      _view.showError(e.toString());
    }
  }

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
  @override
  Future<void> createMultipleTasks(List<Task> tasks) async {
    try {
      if (tasks.isEmpty) {
        throw Exception('No tasks provided for creation.');
      }

      await _repository.createMultipleTasks(tasks);

      final createdIds = <int>{};
      for (final task in tasks) {
        createdIds.add(task.id);

        if (task.reminder != null) {
          try {
            await NotificationService.scheduleReminder(
              'reminder_${task.id}',
              task.reminder!,
              'Reminder: ${task.name}',
              'Your task is due soon!',
            );
          } catch (e) {
            debugPrint(
              'Failed to schedule reminder for task ID ${task.id}: $e',
            );
          }
        }

        if (task.deadline != null) {
          try {
            await NotificationService.scheduleDeadline(
              'deadline_${task.id}',
              task.deadline!,
              'Deadline: ${task.name}',
              'Your task is due!',
            );
          } catch (e) {
            debugPrint(
              'Failed to schedule deadline for task ID ${task.id}: $e',
            );
          }
        }
      }

      _provider
        ..setCreatedIds(createdIds)
        ..setTasks(await _repository.readTasks());
    } catch (e) {
      _view.showError(e.toString());
    }
  }

  /// Fetches all tasks and updates the provider.
  ///
  /// This method is used to refresh the UI with the latest task list.
  ///
  /// Throws an error if fetching tasks fails.
  @override
  Future<void> readTasks() async {
    try {
      _provider
        ..setIsLoading(true)
        ..setTasks(await _repository.readTasks())
        ..setIsLoading(false);
    } catch (e) {
      _view.showError(e.toString());
    }
  }

  /// Retrieves the last task based on order.
  ///
  /// Returns null if no tasks exist.
  @override
  Future<Task?> readLastTask() async => await _repository.readLastTask();

  /// Fetches a task by ID.
  ///
  /// Returns null if the task is not found.
  ///
  /// Parameters:
  /// - [id]: The ID of the task to fetch.
  @override
  Future<Task?> readTaskById(int id) async =>
      await _repository.readTaskById(id);

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
  @override
  Future<void> updateTask(Task task) async {
    try {
      await _repository.updateTask(task);

      _provider
        ..setUpdatedIds({task.id})
        ..setTasks(await _repository.readTasks());

      if (task.reminder != null) {
        await NotificationService.scheduleReminder(
          'reminder_${task.id}',
          task.reminder!,
          'Reminder: ${task.name}',
          'Your task is due soon!',
        );
      }

      if (task.deadline != null) {
        await NotificationService.scheduleDeadline(
          'deadline_${task.id}',
          task.deadline!,
          'Deadline: ${task.name}',
          'Your task is due!',
        );
      }
    } catch (e) {
      _view.showError(e.toString());
    }
  }

  /// Toggles the status of a task (completed/incomplete).
  ///
  /// Automatically refreshes the UI after the status change.
  ///
  /// Parameters:
  /// - [id]: The ID of the task whose status is toggled.
  ///
  /// Throws an error if the task isn't found.
  @override
  Future<void> toggleTaskStatus(int id) async {
    try {
      await _repository.toggleTaskStatus(id);
      _provider.setTasks(await _repository.readTasks());
    } catch (e) {
      _view.showError(e.toString());
    }
  }

  /// Reorders tasks between two indices.
  ///
  /// Ensures valid indices and updates the provider with the reordered tasks.
  ///
  /// Parameters:
  /// - [oldIndex]: The original index of the task.
  /// - [newIndex]: The target index for the task.
  ///
  /// Throws an error if the indices are invalid.
  @override
  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    try {
      await _repository.reorderTasks(oldIndex, newIndex);
      _provider.setTasks(await _repository.readTasks());
    } catch (e) {
      _view.showError(e.toString());
    }
  }

  /// Deletes a task by ID.
  ///
  /// Updates the provider after successful deletion.
  ///
  /// Parameters:
  /// - [id]: The ID of the task to delete.
  ///
  /// Throws an error if the task isn't found.
  @override
  Future<void> deleteTask(int id) async {
    try {
      await _repository.deleteTask(id);
      _provider
        ..setDeletedIds({id})
        ..setTasks(await _repository.readTasks());
    } catch (e) {
      _view.showError(e.toString());
    }
  }

  /// Exports tasks to a file in the specified format.
  ///
  /// Supported formats include JSON, YAML, and CSV.
  ///
  /// Parameters:
  /// - [format]: The format to export the tasks (e.g., 'JSON', 'YAML', 'CSV').
  ///
  /// Throws an error if the format is unsupported or if export fails.
  @override
  Future<void> exportData(String format) async {
    try {
      final tasks = await _repository.readTasks();
      switch (format) {
        case 'JSON':
          await _exportService.toJson(tasks);
          break;
        case 'YAML':
          await _exportService.toYaml(tasks);
          break;
        case 'CSV':
          await _exportService.toCsv(tasks);
          break;
        default:
          throw Exception('Unsupported format');
      }
    } catch (e) {
      _view.showError(e.toString());
    }
  }

  /// Imports tasks from a file in the specified format.
  ///
  /// Supported formats include JSON, YAML, and CSV.
  ///
  /// Parameters:
  /// - [format]: The format to import the tasks (e.g., 'JSON', 'YAML', 'CSV').
  ///
  /// Throws an error if the format is unsupported, if file selection fails,
  /// or if import fails.
  @override
  Future<void> importData(String format) async {
    try {
      if (format.isEmpty) throw Exception('Please select a format first!');
      final filePath = await _importService.pickFile(format);
      if (filePath == null) return;

      List<Task> tasks;
      switch (format) {
        case 'JSON':
          tasks = await _importService.fromJson(filePath);
          break;
        case 'YAML':
          tasks = await _importService.fromYaml(filePath);
          break;
        case 'CSV':
          tasks = await _importService.fromCsv(filePath);
          break;
        default:
          throw Exception('Unsupported format');
      }

      await createMultipleTasks(tasks);
      await readTasks();
    } catch (e) {
      _view.showError(e.toString());
    }
  }
}
