// ignore_for_file: library_private_types_in_public_api

import 'package:daily_tasks/src/common/enum/tasks_action_enum.dart';
import 'package:daily_tasks/src/common/util/snackbar_utils.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/widget/weekly_tasks_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:meta/meta.dart';
import 'package:octopus/octopus.dart';
import 'package:ui/ui.dart';

/// {@template weekly_task_dialog}
/// WeeklyTaskDialog widget that allows users to create or edit a weekly task.
/// {@endtemplate}
class WeeklyTaskDialog extends StatefulWidget {
  /// {@macro weekly_task_dialog}
  const WeeklyTaskDialog({
    this.weeklyTaskModel,
    super.key,
  });

  final WeeklyTaskModel? weeklyTaskModel;

  /// Show the weekly task dialog
  static Future<void> show(BuildContext context) =>
      Octopus.of(context).showDialog<void>((context) => const WeeklyTaskDialog());

  /// Show the weekly task dialog for editing an existing task
  static Future<void> showEdit(BuildContext context, WeeklyTaskModel task) =>
      Octopus.of(context).showDialog<void>((context) => WeeklyTaskDialog(weeklyTaskModel: task));

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  @internal
  static _WeeklyTaskDialogState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_WeeklyTaskDialogState>();

  @override
  State<WeeklyTaskDialog> createState() => _WeeklyTaskDialogState();
}

class _WeeklyTaskDialogState extends State<WeeklyTaskDialog> {
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int taskWeight = 1;

  @override
  void initState() {
    super.initState();
    if (widget.weeklyTaskModel != null) {
      taskTitleController.text = widget.weeklyTaskModel!.title;
      taskDescriptionController.text = widget.weeklyTaskModel!.description ?? '';
      taskWeight = widget.weeklyTaskModel!.weight;
    }
  }

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
    title: Text(widget.weeklyTaskModel != null ? 'Редактировать задачу' : 'Добавить задачу'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Отмена'),
      ),
      TextButton(
        onPressed: () {
          // TODO: Maybe move and separate (?)
          if (formKey.currentState!.validate()) {
            final weeklyTask = widget.weeklyTaskModel == null
                ? WeeklyTaskModel.create(
                    title: taskTitleController.text,
                    description: taskDescriptionController.text.isEmpty ? null : taskDescriptionController.text,
                    weight: taskWeight,
                  )
                : WeeklyTaskModel(
                    id: widget.weeklyTaskModel!.id,
                    title: taskTitleController.text,
                    description: taskDescriptionController.text,
                    weight: taskWeight,
                    isCompleted: widget.weeklyTaskModel!.isCompleted,
                    createdAt: widget.weeklyTaskModel!.createdAt,
                    updatedAt: DateTime.now(),
                  );
            WeeklyTasksScope.controller(context).manageWeeklyTask(
              weeklyTask,
              widget.weeklyTaskModel != null ? TasksActionEnum.update : TasksActionEnum.add,
            );
            Navigator.of(context).pop();
            l.i('Adding task: $weeklyTask');
          } else {
            SnackbarUtils.showSnackBar(
              context,
              const SnackBar(content: Text('Пожалуйста, заполните все поля')),
            );
          }
        },
        child: Text(widget.weeklyTaskModel != null ? 'Сохранить' : 'Добавить'),
      ),
    ],
  );
}

class _DialogBody extends StatelessWidget {
  const _DialogBody();

  @override
  Widget build(BuildContext context) {
    final formKey = WeeklyTaskDialog.maybeOf(context)?.formKey;
    final taskTitleController = WeeklyTaskDialog.maybeOf(context)?.taskTitleController;
    final taskDescriptionController = WeeklyTaskDialog.maybeOf(context)?.taskDescriptionController;
    final setTaskWeight = WeeklyTaskDialog.maybeOf(context)?.setTaskWeight;
    var taskWeight = WeeklyTaskDialog.maybeOf(context)?.taskWeight;
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
