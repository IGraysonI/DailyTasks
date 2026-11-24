import 'package:daily_tasks/src/feature/daily_task_rewards/widget/daily_task_rewards_panel.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_tasks_screen.dart';
import 'package:daily_tasks/src/feature/developer/widget/developer_button.dart';
import 'package:daily_tasks/src/feature/settings/widget/settings_button.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/widget/weekly_task_rewards_panel.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/widget/weekly_tasks_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:ui/ui.dart';

/// {@template home_screen}
/// HomeScreen widget with daily and weekly missions tabs.
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro home_screen}
  const HomeScreen({
    super.key, // ignore: unused_element_parameter
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    l.v('Welcome to HomeScreen');
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                const ArkNavBlock(children: [SettingsButton(), ArkNavSlot()]),
                const SizedBox(width: 16),
                Expanded(
                  child: ArkTabBar(
                    controller: _tabController,
                    items: const [
                      ArkTabItem(label: 'Daily Missions', icon: Icons.today),
                      ArkTabItem(label: 'Weekly Missions', icon: Icons.date_range),
                    ],
                  ),
                ),
                if (kDebugMode) ...const [
                  SizedBox(width: 16),
                  ArkNavBlock(children: [DeveloperButton()]),
                ],
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _MissionsPage(
                  rewardsBuilder: (context, axis) => DailyTaskRewardsPanel(axis: axis),
                  tasks: const DailyTasksScreen(),
                ),
                _MissionsPage(
                  rewardsBuilder: (context, axis) => WeeklyTaskRewardsPanel(axis: axis),
                  tasks: const WeeklyTasksScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Missions tab kept alive so that switching tabs preserves scroll positions and avoids refetching.
class _MissionsPage extends StatefulWidget {
  const _MissionsPage({required this.rewardsBuilder, required this.tasks});

  final Widget Function(BuildContext context, Axis axis) rewardsBuilder;
  final Widget tasks;

  @override
  State<_MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<_MissionsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ArkMissionsLayout(rewardsBuilder: widget.rewardsBuilder, tasks: widget.tasks),
    );
  }
}
