import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novaforge_starter/src/common/model/dependencies.dart';
import 'package:novaforge_starter/src/constants/pubspec.yaml.g.dart';
import 'package:octopus/octopus.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher_string.dart' as url_launcher;

/// {@template developer_screen}
/// DeveloperScreen widget for displaying developer options and information.
/// {@endtemplate}
class DeveloperScreen extends StatelessWidget {
  /// {@macro developer_screen}
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: CustomScrollView(
      slivers: <Widget>[
        // --- App bar --- //
        // TODO: Add localization for the title and remove the const constructor.
        // SliverAppBar(title: Text(Localization.of(context).developer), pinned: true, floating: true, snap: true),
        SliverAppBar(title: Text('Developer'), pinned: true, floating: true, snap: true),

        // --- Application information --- //
        // GroupSeparator(title: Localization.of(context).application),
        GroupSeparator(title: 'Application'),
        _ShowApplicationInfoTile(),
        _ShowLicensePageTile(),
        _ShowApplicationDependenciesTile(),
        _ShowApplicationDevDependenciesTile(),
        _ShowLogsScreenTile(),

        // --- Navigation --- //
        // GroupSeparator(title: Localization.of(context).navigation),
        GroupSeparator(title: 'Navigation'),
        _ResetNavigationTile(),

        // --- Database --- //
        // GroupSeparator(title: Localization.of(context).database),
        GroupSeparator(title: 'Database'),
        _ViewDatabaseTile(),
        _ClearDatabaseTile(),

        // --- Cache --- //
        GroupSeparator(title: 'Cache'),
        _ShowSharedPreferences(),
        _ClearSharedPreferences(),

        // --- Useful links --- //
        // GroupSeparator(title: Localization.of(context).usefulLinks),
        GroupSeparator(title: 'Useful links'),
        _OpenUriTile(title: 'Flutter', description: 'Flutter website', uri: 'https://flutter.dev'),
        _OpenUriTile(title: 'Flutter API', description: 'Framework API', uri: 'https://api.flutter.dev'),
        _OpenUriTile(title: 'Portal', description: 'User portal'),
        _OpenUriTile(title: 'Tasks', description: 'Tasks tracker'),
        _OpenUriTile(title: 'Repository', description: 'Project repository'),
        _OpenUriTile(title: 'Pull requests', description: 'Pull requests list'),
        _OpenUriTile(title: 'Jenkins', description: 'CI/CD pipeline'),
        _OpenUriTile(title: 'Figma', description: 'Designs system'),
        _OpenUriTile(title: 'Firebase', description: 'Firebase console'),
        _OpenUriTile(title: 'Sentry', description: 'Sentry console'),

        // --- Bottom padding --- //
        SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    ),
  );
}

class _CopyTile extends StatelessWidget {
  const _CopyTile({required this.title, this.subtitle, this.content});

  final String title;
  final String? subtitle;
  final String? content;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title),
    subtitle: subtitle != null
        ? Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : null,
    onTap: () {
      Clipboard.setData(ClipboardData(text: content ?? (subtitle == null ? title : '$title: $subtitle')));
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            // content: Text(Localization.of(context).copied),
            content: Text('Copied'),
            duration: Duration(seconds: 3),
          ),
        );
    },
  );
}

class _ShowApplicationInfoTile extends StatelessWidget {
  const _ShowApplicationInfoTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: const Text('Application information'),
        subtitle: const Text(
          'Show information about the application.',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Octopus.of(context).showDialog<void>(
          (context) => AboutDialog(
            applicationName: Pubspec.name,
            applicationVersion: Pubspec.version.representation,
            applicationIcon: const SizedBox.square(dimension: 64, child: Icon(Icons.apps, size: 64)),
            children: <Widget>[
              const _CopyTile(title: 'Name', subtitle: Pubspec.name, content: Pubspec.name),
              _CopyTile(
                title: 'Version',
                subtitle: Pubspec.version.representation,
                content: Pubspec.version.representation,
              ),
              const _CopyTile(title: 'Description', subtitle: Pubspec.description, content: Pubspec.description),
              const _CopyTile(title: 'Homepage', subtitle: Pubspec.homepage, content: Pubspec.homepage),
              const _CopyTile(title: 'Repository', subtitle: Pubspec.repository, content: Pubspec.repository),
            ],
          ),
        ),
      ),
    ),
  );
}

class _ShowLicensePageTile extends StatelessWidget {
  const _ShowLicensePageTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: Text(MaterialLocalizations.of(context).viewLicensesButtonLabel),
        subtitle: Text(
          MaterialLocalizations.of(context).licensesPageTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => showLicensePage(
          context: context,
          applicationName: Pubspec.name,
          applicationVersion: Pubspec.version.representation,
          applicationIcon: const SizedBox.square(
            dimension: 64,
            child: Icon(Icons.apps, size: 64),
          ),
          useRootNavigator: true,
        ),
      ),
    ),
  );
}

class _ShowApplicationDependenciesTile extends StatelessWidget {
  const _ShowApplicationDependenciesTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: const Text('Dependencies'),
        subtitle: const Text(
          'Show dependencies.',
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
                      'Dependencies',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Space.md(),
                    Wrap(
                      children: <Widget>[
                        for (final dependency in Pubspec.dependencies.entries)
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Chip(label: Text('${dependency.key}: ${dependency.value}')),
                          ),
                      ],
                    ),
                    Space.md(),
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

class _ShowApplicationDevDependenciesTile extends StatelessWidget {
  const _ShowApplicationDevDependenciesTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: const Text('Dev Dependencies'),
        subtitle: const Text(
          'Show developers dependencies.',
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
                      'Dev Dependencies',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Space.md(),
                    Wrap(
                      children: <Widget>[
                        for (final dependency in Pubspec.devDependencies.entries)
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Chip(label: Text('${dependency.key}: ${dependency.value}')),
                          ),
                      ],
                    ),
                    Space.md(),
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

class _ShowLogsScreenTile extends StatelessWidget {
  const _ShowLogsScreenTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: const Text('Logs'),
        subtitle: const Text('Show logs.', maxLines: 1, overflow: TextOverflow.ellipsis),
        // onTap: () => LogsDialog.show(context).ignore(),
        onTap: () {
          // TODO: Restore
        },
      ),
    ),
  );
}

class _ResetNavigationTile extends StatelessWidget {
  const _ResetNavigationTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: const Text('Reset navigation'),
        subtitle: const Text(
          'Reset navigation stack.',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Octopus.of(context).popAll(),
      ),
    ),
  );
}

class _ViewDatabaseTile extends StatelessWidget {
  const _ViewDatabaseTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: const Text('View database'),
        subtitle: const Text(
          'View database content.',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Octopus.of(context).showDialog<void>(
          (_) => Dialog(child: DriftDbViewer(Dependencies.of(context).database)),
        ),
      ),
    ),
  );
}

class _ClearDatabaseTile extends StatelessWidget {
  const _ClearDatabaseTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: const Text('Drop database'),
        subtitle: const Text(
          'Clear database content.',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          final db = Dependencies.of(context).database;
          final messenger = ScaffoldMessenger.maybeOf(context);
          Future<void>(() async {
            try {
              await db.customStatement('PRAGMA foreign_keys = OFF');
              try {
                await db.batch((batch) => db.allTables.forEach(batch.deleteAll));
              } finally {
                await db.customStatement('PRAGMA foreign_keys = ON');
              }
              messenger
                ?..clearSnackBars()
                ..showSnackBar(const SnackBar(content: Text('Database cleared'), duration: Duration(seconds: 3)));
            } on Object catch (error) {
              messenger
                ?..clearSnackBars()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Database clear failed: $error'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
            }
          });
        },
      ),
    ),
  );
}

class _OpenUriTile extends StatelessWidget {
  const _OpenUriTile({
    required this.title,
    required this.description,
    this.uri,
    super.key, // ignore: unused_element_parameter
  });

  final String title;
  final String description;
  final String? uri;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: Opacity(
        opacity: uri == null ? 0.5 : 1,
        child: ListTile(
          title: Text(title),
          subtitle: Text(description, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: uri == null ? null : () => url_launcher.launchUrlString(uri!).ignore(),
        ),
      ),
    ),
  );
}

class _ShowSharedPreferences extends StatefulWidget {
  const _ShowSharedPreferences();

  @override
  State<_ShowSharedPreferences> createState() => _ShowSharedPreferencesState();
}

class _ShowSharedPreferencesState extends State<_ShowSharedPreferences> {
  final Map<String, Object?> _sharedPreferencesContent = {};

  @override
  void initState() {
    super.initState();
    _fillContent();
  }

  void _fillContent() {
    final sharedPreferences = Dependencies.of(context).sharedPreferences;
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      _sharedPreferencesContent.putIfAbsent(key, () => sharedPreferences.get(key));
    }
  }

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: const Text('Shared preferences'),
        subtitle: const Text(
          'Show shared preferences content.',
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
                      'Shared preferences',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Space.md(),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        for (final key in _sharedPreferencesContent.keys)
                          ListTile(
                            title: Text(key),
                            subtitle: Text(_sharedPreferencesContent[key].toString()),
                          ),
                      ],
                    ),
                    Space.md(),
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

class _ClearSharedPreferences extends StatelessWidget {
  const _ClearSharedPreferences();

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: ScaffoldPadding.of(context),
    sliver: SliverToBoxAdapter(
      child: ListTile(
        title: const Text('Clear shared preferences'),
        subtitle: const Text(
          'Clear shared preferences content.',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Dependencies.of(context).sharedPreferences.clear();
          ScaffoldMessenger.maybeOf(context)
            ?..clearSnackBars()
            ..showSnackBar(const SnackBar(content: Text('Shared preferences cleared'), duration: Duration(seconds: 3)));
        },
      ),
    ),
  );
}
