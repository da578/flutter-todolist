import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist/contracts/task_presenter_contract.dart';
import 'package:todolist/shared/components/my_filled_button.dart';
import 'package:todolist/shared/components/my_text.dart';
import 'package:todolist/shared/values/screen.dart';
import 'package:todolist/shared/values/theme_values.dart';

class TaskExport extends StatefulWidget {
  final TaskPresenterContract presenter;
  const TaskExport({super.key, required this.presenter});

  @override
  State<TaskExport> createState() => _TaskExportState();
}

class _TaskExportState extends State<TaskExport> {
  Set<String> _selected = {'JSON'};

  void _updateSelected(Set<String> value) {
    setState(() => _selected = value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: Screen.infinity,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              MyText(
                'Export Tasks',
                size: 25,
                color: ThemeValues(context).colorScheme.onSurface,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              Lottie.asset('lib/assets/animations/upload.json'),
              const SizedBox(height: 10),
              SegmentedButton(
                segments: [
                  ButtonSegment<String>(
                    icon: Icon(Icons.insert_drive_file_outlined),
                    label: MyText('JSON'),
                    value: 'JSON',
                  ),
                  ButtonSegment<String>(
                    icon: Icon(Icons.insert_drive_file_outlined),
                    label: MyText('YAML'),
                    value: 'YAML',
                  ),
                  ButtonSegment<String>(
                    icon: Icon(Icons.insert_drive_file_outlined),
                    label: MyText('CSV'),
                    value: 'CSV',
                  ),
                ],
                selected: _selected,
                onSelectionChanged: _updateSelected,
                showSelectedIcon: true,
                selectedIcon: Icon(Icons.check),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: MyFilledButton(
                      child: MyText('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyFilledButton(
                      child: MyText('Confirm'),
                      onPressed: () async {
                        _selected.isNotEmpty
                            ? await widget.presenter.exportData(_selected.first)
                            : null;
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
