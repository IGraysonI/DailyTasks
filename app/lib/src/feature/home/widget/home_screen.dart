import 'package:daily_tasks/src/common/router/routes.dart';
import 'package:daily_tasks/src/common/widget/common_actions.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:octopus/octopus.dart';

/// {@template home_screen}
/// HomeScreen widget.
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

  void onDeveloperIconTap() => Octopus.of(context).push(Routes.developer);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    appBar: AppBar(
      title: const Text('Home'),
      bottom: TabBar(
        tabs: const [
          Tab(text: 'Daily Tasks'),
          Tab(text: 'Weekly Tasks'),
        ],
        controller: _tabController,
      ),
      actions: CommonActions(),
    ),
    body: TabBarView(
      controller: _tabController,
      children: const [
        DailyTasksScreen(),
        // WeeklyTasksScreen(),
        Placeholder(),
      ],
    ),
  );
}
