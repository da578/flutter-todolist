import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:todolist/models/task.dart';
import 'package:yaml/yaml.dart';

class TaskImportService {
  Future<List<Task>> fromJson(String filePath) async {
    final fileContent = await File(filePath).readAsString();
    final jsonData = jsonDecode(fileContent) as List<Map<String, dynamic>>;
    return jsonData.map((taskJson) => Task.fromJson(taskJson)).toList();
  }

  Future<List<Task>> fromYaml(String filePath) async {
    final fileContent = await File(filePath).readAsString();
    final yamlData = loadYaml(fileContent);
    final jsonData = jsonEncode(yamlData['tasks']);
    final jsonTasks = jsonDecode(jsonData) as List<dynamic>;
    return jsonTasks.map((taskJson) => Task.fromJson(taskJson)).toList();
  }

  Future<List<Task>> fromCsv(String filePath) async {
    final fileContent = await File(filePath).readAsString();
    final rows = CsvToListConverter().convert(fileContent);
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
  }

  Future<String?> pickFile(String format) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Import your file',
      type: FileType.any,
    );
    return result?.files.first.path;
  }
}
