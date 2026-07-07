// ignore_for_file: experimental_member_use, library_private_types_in_public_api

import 'package:daily_tasks/src/common/enum/task_rewards_action_enum.dart';
import 'package:daily_tasks/src/common/util/snackbar_utils.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/widget/weekly_task_rewards_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:meta/meta.dart';
import 'package:octopus/octopus.dart';
import 'package:ui/ui.dart';

/// {@template weekly_task_reward_dialog}
/// WeeklyTaskRewardDialog widget that allows users to create or edit a weekly task reward.
/// {@endtemplate}
class WeeklyTaskRewardDialog extends StatefulWidget {
  /// {@macro weekly_task_reward_dialog}
  const WeeklyTaskRewardDialog({
    this.weeklyTaskRewardModel,
    super.key,
  });

  final WeeklyTaskRewardModel? weeklyTaskRewardModel;

  /// Show the weekly task reward dialog
  static Future<void> show(BuildContext context) =>
      Octopus.of(context).showDialog<void>((context) => const WeeklyTaskRewardDialog());

  /// Show the weekly task reward dialog for editing an existing task
  static Future<void> showEdit(BuildContext context, WeeklyTaskRewardModel reward) =>
      Octopus.of(context).showDialog<void>((context) => WeeklyTaskRewardDialog(weeklyTaskRewardModel: reward));

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  @internal
  static _WeeklyTaskRewardDialogState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_WeeklyTaskRewardDialogState>();

  @override
  State<WeeklyTaskRewardDialog> createState() => _WeeklyTaskRewardDialogState();
}

class _WeeklyTaskRewardDialogState extends State<WeeklyTaskRewardDialog> {
  final TextEditingController rewardTitleController = TextEditingController();
  final TextEditingController rewardDescriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int? rewardGoalWeight;

  @override
  void initState() {
    super.initState();
    if (widget.weeklyTaskRewardModel != null) {
      rewardTitleController.text = widget.weeklyTaskRewardModel!.title;
      rewardDescriptionController.text = widget.weeklyTaskRewardModel!.description ?? '';
      rewardGoalWeight = widget.weeklyTaskRewardModel!.goalWeight;
    }
  }

  @override
  void dispose() {
    rewardTitleController.dispose();
    rewardDescriptionController.dispose();
    super.dispose();
  }

  void setTaskRewardWeight(int value) => setState(() => rewardGoalWeight = value);

  @override
  Widget build(BuildContext context) => AlertDialog(
    elevation: 8,
    insetPadding: const EdgeInsets.all(36),
    content: const _DialogBody(),
    title: Text(widget.weeklyTaskRewardModel != null ? 'Редактировать награду' : 'Добавить награду'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Отмена'),
      ),
      TextButton(
        onPressed: () {
          // TODO: Maybe move and separate (?)
          if (formKey.currentState!.validate()) {
            final weeklyTaskReward = widget.weeklyTaskRewardModel == null
                ? WeeklyTaskRewardModel.create(
                    title: rewardTitleController.text,
                    description: rewardDescriptionController.text.isEmpty ? null : rewardDescriptionController.text,
                    goalWeight: rewardGoalWeight!,
                  )
                : WeeklyTaskRewardModel(
                    id: widget.weeklyTaskRewardModel!.id,
                    title: rewardTitleController.text,
                    description: rewardDescriptionController.text,
                    goalWeight: rewardGoalWeight!,
                    createdAt: widget.weeklyTaskRewardModel!.createdAt,
                    updatedAt: DateTime.now(),
                  );
            WeeklyTaskRewardsScope.controller(context).manageWeeklyTaskReward(
              weeklyTaskReward,
              widget.weeklyTaskRewardModel != null ? TaskRewardsActionEnum.update : TaskRewardsActionEnum.add,
            );
            Navigator.of(context).pop();
            l.i('Adding task reward: $weeklyTaskReward');
          } else {
            SnackbarUtils.showSnackBar(
              context,
              const SnackBar(content: Text('Пожалуйста, заполните все поля')),
            );
          }
        },
        child: Text(widget.weeklyTaskRewardModel != null ? 'Сохранить' : 'Добавить'),
      ),
    ],
  );
}

class _DialogBody extends StatelessWidget {
  const _DialogBody();

  @override
  Widget build(BuildContext context) {
    final formKey = WeeklyTaskRewardDialog.maybeOf(context)?.formKey;
    final rewardTitleController = WeeklyTaskRewardDialog.maybeOf(context)?.rewardTitleController;
    final rewardDescriptionController = WeeklyTaskRewardDialog.maybeOf(context)?.rewardDescriptionController;
    final setTaskRewardWeight = WeeklyTaskRewardDialog.maybeOf(context)?.setTaskRewardWeight;
    var rewardGoalWeight = WeeklyTaskRewardDialog.maybeOf(context)?.rewardGoalWeight;
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: rewardTitleController,
            decoration: const InputDecoration(hintText: 'Название награды'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Пожалуйста, введите название награды';
              return null;
            },
          ),
          Space.sm(),
          TextFormField(
            controller: rewardDescriptionController,
            decoration: const InputDecoration(hintText: 'Описание награды'),
          ),
          Space.sm(),
          TextFormField(
            controller: TextEditingController(text: rewardGoalWeight != null ? rewardGoalWeight.toString() : ''),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Цель награды'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Пожалуйста, введите цель награды';
              final intValue = int.tryParse(value);
              if (intValue == null || intValue <= 0) return 'Пожалуйста, введите корректную цель награды';
              return null;
            },
            onChanged: (value) {
              final intValue = int.tryParse(value);
              if (intValue != null && intValue > 0) setTaskRewardWeight!(intValue);
            },
          ),
        ],
      ),
    );
  }
}
