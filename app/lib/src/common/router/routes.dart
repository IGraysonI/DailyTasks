import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_tasks_screen.dart';
import 'package:daily_tasks/src/feature/developer/widget/developer_screen.dart';
import 'package:daily_tasks/src/feature/home/widget/home_screen.dart';
import 'package:daily_tasks/src/feature/settings/widget/settings_screen.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/widget/weekly_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

/// {@template routes}
/// Enum that contains all the routes of the application.
/// {@endtemplate}
enum Routes with OctopusRoute {
  home('home', title: 'Home'),
  dailyTasks('dailyTasks', title: 'Daily Tasks'),
  weeklyTasks('weeklyTasks', title: 'Weekly Tasks'),
  developer('developer', title: 'Developer'),
  settings('settings', title: 'Settings');

  const Routes(this.name, {this.title});

  @override
  final String name;

  @override
  final String? title;

  @override
  Widget builder(BuildContext context, OctopusState state, OctopusNode node) => switch (this) {
    Routes.home => const HomeScreen(),
    Routes.dailyTasks => const DailyTasksScreen(),
    Routes.weeklyTasks => const WeeklyTasksScreen(),
    Routes.developer => const DeveloperScreen(),
    Routes.settings => const SettingsScreen(),
  };
}
