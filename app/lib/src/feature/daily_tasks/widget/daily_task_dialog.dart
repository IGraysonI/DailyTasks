// ignore_for_file: experimental_member_use, library_private_types_in_public_api

import 'package:daily_tasks/src/common/enum/tasks_action_enum.dart';
import 'package:daily_tasks/src/common/util/snackbar_utils.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_tasks_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:meta/meta.dart';
import 'package:octopus/octopus.dart';
import 'package:ui/ui.dart';

/// {@template daily_task_dialog}
/// DailyTaskDialog widget that allows users to create or edit a daily task.
/// {@endtemplate}
class DailyTaskDialog extends StatefulWidget {
  /// {@macro daily_task_dialog}
  const DailyTaskDialog({
    this.dailyTaskModel,
    super.key,
  });

  final DailyTaskModel? dailyTaskModel;

  /// Show the daily task dialog
  static Future<void> show(BuildContext context) =>
      Octopus.of(context).showDialog<void>((context) => const DailyTaskDialog());

  /// Show the daily task dialog for editing an existing task
  static Future<void> showEdit(BuildContext context, DailyTaskModel task) =>
      Octopus.of(context).showDialog<void>((context) => DailyTaskDialog(dailyTaskModel: task));

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
  void initState() {
    super.initState();
    if (widget.dailyTaskModel != null) {
      taskTitleController.text = widget.dailyTaskModel!.title;
      taskDescriptionController.text = widget.dailyTaskModel!.description ?? '';
      taskWeight = widget.dailyTaskModel!.weight;
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
    title: Text(widget.dailyTaskModel != null ? 'Редактировать задачу' : 'Добавить задачу'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Отмена'),
      ),
      TextButton(
        onPressed: () {
          // TODO: Maybe move and separate (?)
          if (formKey.currentState!.validate()) {
            final dailyTask = widget.dailyTaskModel == null
                ? DailyTaskModel.create(
                    title: taskTitleController.text,
                    description: taskDescriptionController.text.isEmpty ? null : taskDescriptionController.text,
                    weight: taskWeight,
                  )
                : DailyTaskModel(
                    id: widget.dailyTaskModel!.id,
                    title: taskTitleController.text,
                    description: taskDescriptionController.text,
                    weight: taskWeight,
                    isCompleted: widget.dailyTaskModel!.isCompleted,
                    createdAt: widget.dailyTaskModel!.createdAt,
                    updatedAt: DateTime.now(),
                  );
            DailyTasksScope.controller(context).manageDailyTask(
              dailyTask,
              widget.dailyTaskModel != null ? TasksActionEnum.update : TasksActionEnum.add,
            );
            Navigator.of(context).pop();
            l.i('Adding task: $dailyTask');
          } else {
            SnackbarUtils.showSnackBar(
              context,
              const SnackBar(content: Text('Пожалуйста, заполните все поля')),
            );
          }
        },
        child: Text(widget.dailyTaskModel != null ? 'Сохранить' : 'Добавить'),
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
