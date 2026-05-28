import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:novaforge_starter/src/feature/settings/widget/application_settings_scope.dart';
import 'package:octopus/octopus.dart';
import 'package:ui/ui.dart';

/// {@template settings_screen}
/// SettingsScreen widget.
/// {@endtemplate}
class SettingsScreen extends StatefulWidget {
  /// {@macro settings_screen}
  const SettingsScreen({
    super.key, // ignore: unused_element
  });

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  @internal
  // ignore: library_private_types_in_public_api
  static _SettingsScreenState? maybeOf(BuildContext context) => context.findAncestorStateOfType<_SettingsScreenState>();

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

/// State for widget SettingsScreen.
class _SettingsScreenState extends State<SettingsScreen> {
  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget configuration changed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: CustomScrollView(
      slivers: [
        // --- App bar --- //
        SliverAppBar(
          // TODO: Add localization
          // title: Text(Localization.of(context).settings),
          title: Text('Settings'),
          pinned: true,
          floating: true,
          snap: true,
        ),

        // --- Theme --- //
        GroupSeparator(title: 'Theme'),
        _ThemeModeSelector(),
      ],
    ),
  );
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: const Text('Theme mode'),
        subtitle: Text(
          // MaterialLocalizations.of(context).licensesPageTitle,
          'Selected theme mode: ${Theme.of(context).brightness.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Octopus.of(context).showDialog<void>(
          (context) => Dialog(
            insetPadding: const EdgeInsets.all(64),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Theme mode',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Space.md(),
                    DropdownButtonFormField<ThemeMode>(
                      initialValue: ApplicationSettingsScope.settingsOf(context).applicationTheme!.themeMode,
                      items: ThemeMode.values
                          .map(
                            (value) => DropdownMenuItem<ThemeMode>(
                              value: value,
                              child: Text(value.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        final applicationSettingsController = ApplicationSettingsScope.controllerOf(context);
                        final applicationSettings = ApplicationSettingsScope.settingsOf(context);
                        applicationSettingsController.updateApplicationSettings(
                          applicationSettings.copyWith(
                            applicationTheme: applicationSettings.applicationTheme!.copyWith(themeMode: value),
                          ),
                        );
                      },
                      decoration: const InputDecoration(labelText: 'Select theme mode'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
