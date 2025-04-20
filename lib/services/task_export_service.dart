import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:todolist/models/task.dart';

/// A service class for exporting tasks to various file formats.
///
/// This class supports exporting tasks to JSON, YAML, and CSV files.
/// It handles file saving and data conversion into the desired format.
class TaskExportService {
  /// Exports tasks to a JSON file.
  ///
  /// Parameters:
  /// - [tasks]: The list of tasks to export.
  ///
  /// Throws an error if the task list is empty or if file saving fails.
  Future<void> toJson(List<Task> tasks) async {
    if (tasks.isEmpty) throw Exception('You cannot export an empty task list.');

    try {
      final jsonTasks = jsonEncode(tasks.map((task) => task.toJson()).toList());
      await _saveFile('tasks.json', jsonTasks);
    } catch (e) {
      throw Exception('Failed to export tasks to JSON: $e');
    }
  }

  /// Exports tasks to a YAML file.
  ///
  /// Parameters:
  /// - [tasks]: The list of tasks to export.
  ///
  /// Throws an error if the task list is empty or if file saving fails.
  Future<void> toYaml(List<Task> tasks) async {
    if (tasks.isEmpty) throw Exception('You cannot export empty tasks!');

    try {
      final jsonTasks = tasks.map((task) => task.toJson()).toList();
      final yamlTasks = json2yaml({'tasks': jsonTasks});
      await _saveFile('tasks.yaml', yamlTasks);
    } catch (e) {
      throw Exception('Failed to export tasks to YAML: $e');
    }
  }

  /// Exports tasks to a CSV file.
  ///
  /// Parameters:
  /// - [tasks]: The list of tasks to export.
  ///
  /// Throws an error if the task list is empty or if file saving fails.
  Future<void> toCsv(List<Task> tasks) async {
    if (tasks.isEmpty) throw Exception('You cannot export an empty task list.');

    try {
      final header = [
        'id',
        'name',
        'description',
        'status',
        'order',
        'reminder',
        'deadline',
      ];
      final rows = [
        header,
        ...tasks.map(
          (task) => [
            task.id.toString(),
            task.name,
            task.description,
            task.status.toString(),
            task.order.toString(),
            task.reminder?.toIso8601String() ?? '',
            task.deadline?.toIso8601String() ?? '',
          ],
        ),
      ];
      final csvTasks = ListToCsvConverter().convert(rows);
      await _saveFile('tasks.csv', csvTasks);
    } catch (e) {
      debugPrint('Failed to export tasks to CSV: $e');
      rethrow;
    }
  }

  /// Saves the exported file to the user's device.
  ///
  /// Parameters:
  /// - [fileName]: The name of the file to save.
  /// - [content]: The content of the file to save.
  ///
  /// Throws an error if file saving fails.
  Future<void> _saveFile(String fileName, String content) async {
    try {
      final bytes = Uint8List.fromList(utf8.encode(content));
      await FilePicker.platform.saveFile(
        fileName: fileName,
        bytes: bytes,
        dialogTitle: 'Save your file',
        type: FileType.custom,
        allowedExtensions: [fileName.split('.').last],
      );
    } catch (e) {
      throw Exception('Failed to save file "$fileName": $e');
    }
  }
}
