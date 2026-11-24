import 'package:daily_tasks/src/common/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';
import 'package:ui/ui.dart';

/// {@template settings_button}
/// SettingsButton widget for navigating to the settings screen.
/// {@endtemplate}
class SettingsButton extends StatelessWidget {
  /// {@macro settings_button}
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) => ArkNavSlot(
    icon: Icons.settings,
    tooltip: 'Settings',
    onPressed: () => Octopus.of(context).push(Routes.settings),
  );
}
