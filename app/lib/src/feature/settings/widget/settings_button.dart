import 'package:flutter/material.dart';
import 'package:novaforge_starter/src/common/router/routes.dart';
import 'package:octopus/octopus.dart';

/// {@template settings_button}
/// SettingsButton widget for navigating to the settings screen.
/// {@endtemplate}
class SettingsButton extends StatelessWidget {
  /// {@macro settings_button}
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.settings),
    // TODO: Add localization
    // tooltip: Localization.of(context).settings,
    tooltip: 'Settings',
    onPressed: () => Octopus.of(context).push(Routes.settings),
  );
}
