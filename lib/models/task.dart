import 'package:isar/isar.dart';

part 'task.g.dart';

/// Model for representing a task with its details, status, and priority.
///
/// This class is used in conjunction with Isar as a database collection.
@collection
class Task {
  Id id = Isar.autoIncrement;
  String name;
  String description;
  bool status;
  int? order;
  DateTime? reminder;
  DateTime? deadline;

  /// Constructor for creating a new Task.
  ///
  /// - [name]: Name of the task (required).
  /// - [description]: Description of the task (default: empty string).
  /// - [status]: Status of the task (default: false, incomplete).
  /// - [order]: Order of the task (optional).
  /// - [reminder]: Reminder date (optional).
  /// - [deadline]: Deadline date (optional).
  Task({
    this.id = Isar.autoIncrement,
    required this.name,
    this.description = '',
    this.status = false,
    this.order,
    this.reminder,
    this.deadline,
  });

  /// Converts the Task object to a JSON map.
  ///
  /// Converts the Task object into a map that can be saved as JSON.
  ///
  /// - [reminder]: Converted to ISO 8601 string.
  /// - [deadline]: Converted to ISO 8601 string.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'order': order,
      'reminder': reminder?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
    };
  }

  /// Creates a Task object from a JSON map.
  ///
  /// Constructs a Task object from imported JSON data.
  ///
  /// - [json]: JSON data containing task properties.
  ///
  /// Returns a [Task] object.
  ///
  /// Example input:
  /// ```json
  /// {
  ///   "id": 1,
  ///   "name": "Task 1",
  ///   "description": "This is a description",
  ///   "status": false,
  ///   "order": 0,
  ///   "reminder": "2024-01-01T12:00:00Z",
  ///   "deadline": "2024-01-02T12:00:00Z"
  /// }
  /// ```
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as Id? ?? Isar.autoIncrement,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      status: json['status'] as bool? ?? false,
      order: json['order'] as int?,
      reminder:
          json['reminder'] == null
              ? null
              : DateTime.parse(json['reminder'] as String),
      deadline:
          json['deadline'] == null
              ? null
              : DateTime.parse(json['deadline'] as String),
    );
  }
}
