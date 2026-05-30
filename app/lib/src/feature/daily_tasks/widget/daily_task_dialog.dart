// ignore_for_file: library_private_types_in_public_api

import 'package:daily_tasks/src/common/util/snackbar_utils.dart';
import 'package:daily_tasks/src/feature/daily_tasks/enum/tasks_action_enum.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_tasks_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:meta/meta.dart';
import 'package:octopus/octopus.dart';
import 'package:ui/ui.dart';

/// {@template logs_dialog}
/// LogsDialog widget.
/// {@endtemplate}
class DailyTaskDialog extends StatefulWidget {
  /// {@macro logs_dialog}
  const DailyTaskDialog({super.key});

  /// Show the logs screen
  static Future<void> show(BuildContext context) =>
      Octopus.of(context).showDialog<void>((context) => const DailyTaskDialog());

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  @internal
  static _DailyTaskDialogState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_DailyTaskDialogState>();

  @override
  State<DailyTaskDialog> createState() => _DailyTaskDialogState();
}

class _DailyTaskDialogState extends State<DailyTaskDialog> {
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int taskWeight = 1;

  @override
  void dispose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  void setTaskWeight(int value) => setState(() => taskWeight = value);

  @override
  Widget build(BuildContext context) => AlertDialog(
    elevation: 8,
    insetPadding: const EdgeInsets.all(36),
    content: const _DialogBody(),
    title: const Text('Добавить задачу'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Отмена'),
      ),
      TextButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // TODO: Перенести в репозиторий?
            final dailyTask = DailyTaskModel(
              // TODO: Генерация ID
              id: '0',
              title: taskTitleController.text,
              description: taskDescriptionController.text,
              weight: taskWeight,
              isCompleted: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            DailyTasksScope.controller(context).manageDailyTask(dailyTask, TasksActionEnum.add);
            Navigator.of(context).pop();
            l.i('Adding task: $dailyTask');
          } else {
            SnackbarUtils.showSnackBar(
              context,
              const SnackBar(content: Text('Пожалуйста, заполните все поля')),
            );
          }
        },
        child: const Text('Добавить'),
      ),
    ],
  );
}

class _DialogBody extends StatelessWidget {
  const _DialogBody();

  @override
  Widget build(BuildContext context) {
    final formKey = DailyTaskDialog.maybeOf(context)?.formKey;
    final taskTitleController = DailyTaskDialog.maybeOf(context)?.taskTitleController;
    final taskDescriptionController = DailyTaskDialog.maybeOf(context)?.taskDescriptionController;
    final setTaskWeight = DailyTaskDialog.maybeOf(context)?.setTaskWeight;
    var taskWeight = DailyTaskDialog.maybeOf(context)?.taskWeight;
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: taskTitleController,
            decoration: const InputDecoration(hintText: 'Название задачи'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Пожалуйста, введите название задачи';
              return null;
            },
          ),
          Space.sm(),
          TextFormField(
            controller: taskDescriptionController,
            decoration: const InputDecoration(hintText: 'Описание задачи'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Пожалуйста, введите описание задачи';
              return null;
            },
          ),
          Space.sm(),
          DropdownButtonFormField<int>(
            initialValue: taskWeight,
            items: List.generate(
              3,
              (index) => DropdownMenuItem<int>(
                value: index + 1,
                child: Text((index + 1).toString()),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                taskWeight = value;
                setTaskWeight!(value);
              }
            },
            decoration: const InputDecoration(labelText: 'Вес задачи'),
            validator: (value) {
              if (value == null || value == 0) return 'Пожалуйста, введите вес задачи';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
