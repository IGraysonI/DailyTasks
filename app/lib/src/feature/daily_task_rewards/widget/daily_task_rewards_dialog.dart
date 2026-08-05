import 'package:daily_tasks/src/common/util/snackbar_utils.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/widget/daily_task_rewards_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';
import 'package:ui/ui.dart';

/// {@template daily_task_reward_dialog}
/// DailyTaskRewardDialog widget that allows users to create or edit a daily task reward.
/// {@endtemplate}
class DailyTaskRewardDialog extends StatefulWidget {
  /// {@macro daily_task_reward_dialog}
  const DailyTaskRewardDialog({
    this.dailyTaskRewardModel,
    super.key,
  });

  final DailyTaskRewardModel? dailyTaskRewardModel;

  /// Show the daily task reward dialog
  static Future<void> show(BuildContext context) =>
      // ignore: experimental_member_use
      Octopus.of(context).showDialog<void>((context) => const DailyTaskRewardDialog());

  /// Show the daily task reward dialog for editing an existing task
  static Future<void> showEdit(BuildContext context, DailyTaskRewardModel reward) =>
      Octopus.of(context).showDialog<void>((context) => DailyTaskRewardDialog(dailyTaskRewardModel: reward));

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  static _DailyTaskRewardDialogState? _maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_DailyTaskRewardDialogState>();

  @override
  State<DailyTaskRewardDialog> createState() => _DailyTaskRewardDialogState();
}

class _DailyTaskRewardDialogState extends State<DailyTaskRewardDialog> {
  final TextEditingController rewardTitleController = TextEditingController();
  final TextEditingController rewardDescriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int? rewardGoalWeight;

  @override
  void initState() {
    super.initState();
    if (widget.dailyTaskRewardModel != null) {
      rewardTitleController.text = widget.dailyTaskRewardModel!.title;
      rewardDescriptionController.text = widget.dailyTaskRewardModel!.description ?? '';
      rewardGoalWeight = widget.dailyTaskRewardModel!.goalWeight;
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
    title: Text(widget.dailyTaskRewardModel != null ? 'Редактировать награду' : 'Добавить награду'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Отмена'),
      ),
      TextButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (widget.dailyTaskRewardModel != null) {
              DailyTaskRewardsScope.controller(context).updateDailyTaskReward(
                id: widget.dailyTaskRewardModel!.id,
                title: rewardTitleController.text,
                description: rewardDescriptionController.text,
                goalWeight: rewardGoalWeight!,
              );
            } else {
              DailyTaskRewardsScope.controller(context).createDailyTaskReward(
                title: rewardTitleController.text,
                description: rewardDescriptionController.text.isEmpty ? null : rewardDescriptionController.text,
                goalWeight: rewardGoalWeight!,
              );
            }
            Navigator.of(context).pop();
          } else {
            SnackbarUtils.showSnackBar(
              context,
              const SnackBar(content: Text('Пожалуйста, заполните все поля')),
            );
          }
        },
        child: Text(widget.dailyTaskRewardModel != null ? 'Сохранить' : 'Добавить'),
      ),
    ],
  );
}

class _DialogBody extends StatelessWidget {
  const _DialogBody();

  @override
  Widget build(BuildContext context) {
    final formKey = DailyTaskRewardDialog._maybeOf(context)?.formKey;
    final rewardTitleController = DailyTaskRewardDialog._maybeOf(context)?.rewardTitleController;
    final rewardDescriptionController = DailyTaskRewardDialog._maybeOf(context)?.rewardDescriptionController;
    final setTaskRewardWeight = DailyTaskRewardDialog._maybeOf(context)?.setTaskRewardWeight;
    var rewardGoalWeight = DailyTaskRewardDialog._maybeOf(context)?.rewardGoalWeight;
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
