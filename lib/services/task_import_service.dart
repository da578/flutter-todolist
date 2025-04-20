import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:todolist/models/task.dart';
import 'package:yaml/yaml.dart';

/// A service class for importing tasks from files in various formats.
///
/// This class supports importing tasks from JSON, YAML, and CSV files.
/// It handles file selection, parsing, and conversion into a list of [Task] objects.
class TaskImportService {
  /// Imports tasks from a JSON file.
  ///
  /// Parameters:
  /// - [filePath]: The path to the JSON file.
  ///
  /// Returns a list of [Task] objects parsed from the file.
  ///
  /// Throws an error if the file is not found, invalid, or cannot be parsed.
  Future<List<Task>> fromJson(String filePath) async {
    try {
      final fileContent = await File(filePath).readAsString();
      final jsonData = jsonDecode(fileContent) as List<dynamic>;
      return jsonData.map((taskJson) => Task.fromJson(taskJson)).toList();
    } catch (e) {
      throw Exception('Failed to import tasks from JSON: $e');
    }
  }

  /// Imports tasks from a YAML file.
  ///
  /// Parameters:
  /// - [filePath]: The path to the YAML file.
  ///
  /// Returns a list of [Task] objects parsed from the file.
  ///
  /// Throws an error if the file is not found, invalid, or cannot be parsed.
  Future<List<Task>> fromYaml(String filePath) async {
    try {
      final fileContent = await File(filePath).readAsString();
      final yamlData = loadYaml(fileContent);
      if (yamlData['tasks'] == null) {
        throw Exception('The YAML file does not contain a "tasks" key.');
      }
      final jsonData = jsonEncode(yamlData['tasks']);
      final jsonTasks = jsonDecode(jsonData) as List<dynamic>;
      return jsonTasks.map((taskJson) => Task.fromJson(taskJson)).toList();
    } catch (e) {
      throw Exception('Failed to import tasks from YAML: $e');
    }
  }

  /// Imports tasks from a CSV file.
  ///
  /// Parameters:
  /// - [filePath]: The path to the CSV file.
  ///
  /// Returns a list of [Task] objects parsed from the file.
  ///
  /// Throws an error if the file is not found, invalid, or cannot be parsed.
  Future<List<Task>> fromCsv(String filePath) async {
    try {
      final fileContent = await File(filePath).readAsString();
      final rows = CsvToListConverter().convert(fileContent);

      // Ensure the CSV file has a header row
      if (rows.isEmpty || rows.first.isEmpty) {
        throw Exception('The CSV file is empty or missing headers.');
      }

      final header = rows.first.cast<String>();
      final taskRows = rows.skip(1);

      return taskRows.map((row) {
        final taskMap = Map<String, dynamic>.fromIterables(header, row);

        return Task(
          id: taskMap['id'],
          name: taskMap['name'],
          description: taskMap['description'],
          status: bool.parse(taskMap['status']),
          order: taskMap['order'],
          reminder:
              taskMap['reminder'] == ''
                  ? null
                  : DateTime.parse(taskMap['reminder']),
          deadline:
              taskMap['deadline'] == ''
                  ? null
                  : DateTime.parse(taskMap['deadline']),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to import tasks from CSV: $e');
    }
  }

  /// Opens a file picker dialog to select a file for importing tasks.
  ///
  /// Parameters:
  /// - [format]: The expected file format (e.g., 'JSON', 'YAML', 'CSV').
  ///
  /// Returns the selected file's path or null if no file is selected.
  Future<String?> pickFile(String format) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Import your $format file',
        type: FileType.any,
      );
      return result?.files.first.path;
    } catch (e) {
      throw Exception('Failed to pick file: $e');
    }
  }
}
