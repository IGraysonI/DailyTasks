import 'package:flutter/material.dart';
import 'package:novaforge_starter/src/feature/developer/widget/developer_screen.dart';
import 'package:novaforge_starter/src/feature/home/widget/home_screen.dart';
import 'package:novaforge_starter/src/feature/settings/widget/settings_screen.dart';
import 'package:octopus/octopus.dart';

/// {@template routes}
/// Enum that contains all the routes of the application.
/// {@endtemplate}
enum Routes with OctopusRoute {
  home('home', title: 'Home'),
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
    Routes.developer => const DeveloperScreen(),
    Routes.settings => const SettingsScreen(),
  };
}
