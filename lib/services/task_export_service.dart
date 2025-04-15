import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:todolist/models/task.dart';

class TaskExportService {
  Future<void> toJson(List<Task> tasks) async {
    if (tasks.isEmpty) throw Exception('You cannot export empty tasks!');
    final jsonTasks = jsonEncode(tasks);
    await _saveFile('tasks.json', jsonTasks);
  }

  Future<void> toYaml(List<Task> tasks) async {
    if (tasks.isEmpty) throw Exception('You cannot export empty tasks!');
    final jsonTasks = tasks.map((task) => task.toJson()).toList();
    final yamlTasks = json2yaml({'tasks': jsonTasks});
    await _saveFile('tasks.yaml', yamlTasks);
  }

  Future<void> toCsv(List<Task> tasks) async {
    if (tasks.isEmpty) throw Exception('You cannot export empty tasks!');
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
          task.id,
          task.name,
          task.description,
          task.status,
          task.order,
          task.reminder?.toIso8601String() ?? '',
          task.deadline?.toIso8601String() ?? '',
        ],
      ),
    ];
    final csvTasks = ListToCsvConverter().convert(rows);
    await _saveFile('tasks.csv', csvTasks);
  }

  Future<void> _saveFile(String fileName, String bytes) async {
    await FilePicker.platform.saveFile(
      fileName: fileName,
      bytes: Uint8List.fromList(utf8.encode(bytes)),
      dialogTitle: 'Save your file',
      type: FileType.custom,
      allowedExtensions: [fileName.split('.').last],
    );
  }
}
