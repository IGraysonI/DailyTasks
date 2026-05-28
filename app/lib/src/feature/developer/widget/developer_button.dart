import 'package:flutter/material.dart';
import 'package:novaforge_starter/src/common/router/routes.dart';
import 'package:octopus/octopus.dart';

/// {@template developer_button}
/// DeveloperButton widget for navigating to the developer screen.
/// {@endtemplate}
class DeveloperButton extends StatelessWidget {
  /// {@macro developer_button}
  const DeveloperButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.developer_mode),
    // TODO: Add localization
    // tooltip: Localization.of(context).developer,
    tooltip: 'Developer Button',
    onPressed: () => Octopus.of(context).push(Routes.developer),
  );
}
