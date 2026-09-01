import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/feature/settings/widget/application_settings_scope.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:ui/ui.dart';

/// {@template settings_screen}
/// SettingsScreen widget.
/// {@endtemplate}
class SettingsScreen extends StatefulWidget {
  /// {@macro settings_screen}
  const SettingsScreen({
    super.key, // ignore: unused_element
  });

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
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      slivers: [
        // --- App bar --- //
        const SliverAppBar(
          // TODO: Add localization
          // title: Text(Localization.of(context).settings),
          title: Text('Settings'),
          pinned: true,
          floating: true,
          snap: true,
        ),

        // --- Theme --- //
        const GroupSeparator(title: 'Theme'),
        const _ThemeModeSelector(),

        // --- Locale --- //
        const GroupSeparator(title: 'Locale'),
        const _LocaleSelector(),
        SliverPadding(
          padding: ScaffoldPadding.of(context),
          sliver: SliverToBoxAdapter(
            child: ListTile(
              title: Text('Locale test: ${Sheet1Localization.of(context).yes}'),
            ),
          ),
        ),

        // --- Notifications --- //
        const GroupSeparator(title: 'Notifications'),
        const _NotificationTest(),
        const _DailyNotificationSettings(),
        const _WeeklyNotificationSettings(),

        // --- Tasks reset --- //
        const GroupSeparator(title: 'Tasks reset'),
        const _DailyTasksResetToggle(),
        const _WeeklyTasksResetToggle(),
      ],
    ),
  );
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context) {
    final applicationSettings = ApplicationSettingsScope.settingsOf(context);
    final applicationSettingsController = ApplicationSettingsScope.controllerOf(context);
    return SliverPadding(
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
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton<ThemeMode>(
              value: ApplicationSettingsScope.settingsOf(context).applicationTheme!.themeMode,
              focusColor: Theme.of(context).colorScheme.surface,
              items: ThemeMode.values
                  .map(
                    (value) => DropdownMenuItem<ThemeMode>(
                      value: value,
                      child: Text(value.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => applicationSettingsController.updateApplicationSettings(
                applicationSettings.copyWith(
                  applicationTheme: applicationSettings.applicationTheme!.copyWith(themeMode: value),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LocaleSelector extends StatefulWidget {
  const _LocaleSelector();

  @override
  State<_LocaleSelector> createState() => _LocaleSelectorState();
}

class _LocaleSelectorState extends State<_LocaleSelector> {
  @override
  Widget build(BuildContext context) {
    final applicationSettings = ApplicationSettingsScope.settingsOf(context);
    final applicationSettingsController = ApplicationSettingsScope.controllerOf(context);
    return SliverPadding(
      padding: ScaffoldPadding.of(context),
      sliver: SliverToBoxAdapter(
        child: ListTile(
          title: const Text('Language'),
          subtitle: const Text(
            'Choose your preferred language for the application.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: Sheet1Localization.of(context).localeName,
              focusColor: Theme.of(context).colorScheme.surface,
              items: Sheet1Localization.supportedLocales
                  .map(
                    (locale) => DropdownMenuItem(
                      value: locale.languageCode,
                      onTap: () => applicationSettingsController.updateApplicationSettings(
                        applicationSettings.copyWith(locale: locale),
                      ),
                      child: Text(locale.toLanguageTag()),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() {}),
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyNotificationSettings extends StatelessWidget {
  const _DailyNotificationSettings();

  @override
  Widget build(BuildContext context) {
    final applicationSettings = ApplicationSettingsScope.settingsOf(context);
    final applicationSettingsController = ApplicationSettingsScope.controllerOf(context);
    return SliverPadding(
      padding: ScaffoldPadding.of(context),
      sliver: SliverToBoxAdapter(
        child: ListTile(
          title: const Text('Daily Notifications'),
          subtitle: const Text(
            'Receive notifications for daily tasks (e.g., reminders, tasks reset).',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Switch(
            value: applicationSettings.enableDailyTasksNotifications ?? true,
            onChanged: (value) => applicationSettingsController.updateApplicationSettings(
              applicationSettings.copyWith(enableDailyTasksNotifications: value),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyNotificationSettings extends StatelessWidget {
  const _WeeklyNotificationSettings();

  @override
  Widget build(BuildContext context) {
    final applicationSettings = ApplicationSettingsScope.settingsOf(context);
    final applicationSettingsController = ApplicationSettingsScope.controllerOf(context);
    return SliverPadding(
      padding: ScaffoldPadding.of(context),
      sliver: SliverToBoxAdapter(
        child: ListTile(
          title: const Text('Weekly Notifications'),
          subtitle: const Text(
            'Receive notifications for weekly tasks (e.g., reminders, tasks reset).',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Switch(
            value: applicationSettings.enableWeeklyTasksNotifications ?? true,
            onChanged: (value) => applicationSettingsController.updateApplicationSettings(
              applicationSettings.copyWith(enableWeeklyTasksNotifications: value),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationTest extends StatelessWidget {
  const _NotificationTest();

  @override
  Widget build(BuildContext context) {
    final notificationService = Dependencies.of(context).flutterLocalNotificationsPlugin;
    return SliverPadding(
      padding: ScaffoldPadding.of(context),
      sliver: SliverToBoxAdapter(
        child: ListTile(
          title: const Text('Test Notification'),
          subtitle: const Text(
            'Send a test notification to verify the notification system is working correctly.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: ElevatedButton(
            onPressed: () async => await notificationService.show(
              id: 1,
              title: 'Test Notification',
              body: 'This is a test notification from the Daily Tasks app.',
            ),
            child: const Text('Send Test'),
          ),
        ),
      ),
    );
  }
}

class _DailyTasksResetToggle extends StatelessWidget {
  const _DailyTasksResetToggle();

  @override
  Widget build(BuildContext context) {
    final applicationSettings = ApplicationSettingsScope.settingsOf(context);
    final applicationSettingsController = ApplicationSettingsScope.controllerOf(context);
    return SliverPadding(
      padding: ScaffoldPadding.of(context),
      sliver: SliverToBoxAdapter(
        child: ListTile(
          title: const Text('Reset Daily Tasks'),
          subtitle: const Text(
            'Reset daily tasks when a new day starts.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Switch(
            value: applicationSettings.resetDailyTasksOnNewDayStart ?? true,
            onChanged: (value) {
              applicationSettingsController.updateApplicationSettings(
                applicationSettings.copyWith(resetDailyTasksOnNewDayStart: value),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WeeklyTasksResetToggle extends StatelessWidget {
  const _WeeklyTasksResetToggle();

  @override
  Widget build(BuildContext context) {
    final applicationSettings = ApplicationSettingsScope.settingsOf(context);
    final applicationSettingsController = ApplicationSettingsScope.controllerOf(context);
    return SliverPadding(
      padding: ScaffoldPadding.of(context),
      sliver: SliverToBoxAdapter(
        child: ListTile(
          title: const Text('Reset Weekly Tasks'),
          subtitle: const Text(
            'Reset weekly tasks when a new week starts.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Switch(
            value: applicationSettings.resetWeeklyTasksOnNewWeekStart ?? true,
            onChanged: (value) {
              applicationSettingsController.updateApplicationSettings(
                applicationSettings.copyWith(resetWeeklyTasksOnNewWeekStart: value),
              );
            },
          ),
        ),
      ),
    );
  }
}
