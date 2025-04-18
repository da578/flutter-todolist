import 'package:flutter/material.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/theme_values.dart';

/// TaskSort is a popup menu that allows users to sort tasks based on different criteria.
///
/// This widget provides options for sorting tasks in various orders, such as ascending,
/// descending, by deadline, or by reminder. It dynamically updates the task list when
/// a sorting option is selected.
class TaskSort extends StatefulWidget {
  /// The presenter responsible for handling business logic related to tasks.
  final TaskPresenterContract _presenter;

  /// Constructor for [TaskSort].
  ///
  /// Parameters:
  /// - [presenter]: The task presenter for handling sorting operations.
  const TaskSort({super.key, required TaskPresenterContract presenter})
    : _presenter = presenter;

  @override
  State<TaskSort> createState() => _TaskSortState();
}

class _TaskSortState extends State<TaskSort> {
  /// The currently selected sorting option.
  int _selectedValue = 0;

  /// A list of available sorting options.
  final List<Map<String, dynamic>> _sortOptions = [
    {'label': 'Default', 'value': 0, 'option': 'ascending'},
    {'label': 'Descending (Z to A)', 'value': 1, 'option': 'descending'},
    {'label': 'Completed First', 'value': 2, 'option': 'completed_first'},
    {'label': 'Nearest Deadline', 'value': 3, 'option': 'nearest_deadline'},
    {'label': 'Farthest Deadline', 'value': 4, 'option': 'farthest_deadline'},
    {'label': 'Nearest Reminder', 'value': 5, 'option': 'nearest_reminder'},
    {'label': 'Farthest Reminder', 'value': 6, 'option': 'farthest_reminder'},
    {'label': 'Newest First', 'value': 7, 'option': 'newest_first'},
    {'label': 'Oldest First', 'value': 8, 'option': 'oldest_first'},
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      borderRadius: BorderRadius.circular(20),
      color: ThemeValues(context).colorScheme.surfaceContainerHigh,
      icon: Icon(
        Icons.sort_rounded,
        color:
            _selectedValue == 0
                ? ThemeValues(context).colorScheme.onSurface
                : ThemeValues(context).colorScheme.primary,
      ),
      elevation: 1,
      onSelected: (value) async {
        final selectedOption = _sortOptions.firstWhere(
          (option) => option['value'] == value,
        );
        await widget._presenter.sortTasks(selectedOption['option']);
        setState(() => _selectedValue = value);
      },
      itemBuilder:
          (_) =>
              _sortOptions
                  .map(
                    (option) => PopupMenuItem<int>(
                      value: option['value'],
                      child: Row(
                        children: [
                          Expanded(child: MyText(option['label'])),
                          Radio<int>(
                            value: option['value'],
                            groupValue: _selectedValue,
                            onChanged:
                                null, // Disable direct interaction with Radio
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (states) =>
                                  states.contains(WidgetState.selected)
                                      ? ThemeValues(context).colorScheme.primary
                                      : ThemeValues(
                                        context,
                                      ).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
    );
  }
}
