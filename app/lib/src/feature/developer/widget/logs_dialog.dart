// ignore_for_file: experimental_member_use

import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/date_util.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:l/l.dart';
import 'package:octopus/octopus.dart';
import 'package:ui/ui.dart';

/// {@template logs_dialog}
/// LogsDialog widget to display logs in a dialog.
/// {@endtemplate}
class LogsDialog extends StatelessWidget {
  /// {@macro logs_dialog}
  const LogsDialog({super.key});

  /// Show the logs screen
  static Future<void> show(BuildContext context) =>
      Octopus.of(context).showDialog<void>((context) => const LogsDialog());

  @override
  Widget build(BuildContext context) => const Dialog(
    elevation: 8,
    insetPadding: EdgeInsets.all(36),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    child: _LogsList(),
  );
}

class _LogsList extends StatefulWidget {
  const _LogsList();

  @override
  State<_LogsList> createState() => _LogsListState();
}

/// State for widget _LogsList.
class _LogsListState extends State<_LogsList> {
  final TextEditingController _controller = TextEditingController();
  late List<LogMessage> logs = <LogMessage>[], filteredLogs = <LogMessage>[];

  @override
  void initState() {
    super.initState();
    _getLogs();
    _controller.addListener(_filter);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getLogs() async {
    final sqlDatabaseSource = SqlDatabaseSource(Dependencies.of(context).database);
    logs = await sqlDatabaseSource.dao<LogsDao>().getAllLogs().then<List<LogMessage>>(
      (logs) => logs
          .map<LogMessage>(
            (l) => l.stackTrace != null
                ? LogMessageError(
                    timestamp: l.timestamp,
                    level: LogLevel.fromValue(l.level),
                    message: l.message,
                    stackTrace: StackTrace.fromString(l.stackTrace!),
                  )
                : LogMessageVerbose(
                    timestamp: l.timestamp,
                    level: LogLevel.fromValue(l.level),
                    message: l.message,
                  ),
          )
          .toList(),
    );
    await _filter();
  }

  Future<void> _filter() async {
    final search = _controller.text.toLowerCase();
    final stopwatch = Stopwatch()..start();
    final buffer = logs.toList();
    try {
      LogMessage log;
      var pos = 0;
      for (var i = 0; i < buffer.length; i++) {
        if (stopwatch.elapsedMilliseconds > 8) await Future<void>.delayed(Duration.zero);
        log = logs[i];
        if (log.message.toString().toLowerCase().contains(search)) {
          buffer[pos] = log;
          pos++;
        }
      }
      filteredLogs = buffer..length = pos;
    } finally {
      stopwatch.stop();
    }
    if (mounted) setState(() {});
  }

  Future<void> _deleteAllLogs() async {
    final sqlDatabaseSource = SqlDatabaseSource(Dependencies.of(context).database);
    await sqlDatabaseSource.dao<LogsDao>().deleteAllLogs();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          title: Text('Logs (${filteredLogs.length})'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteAllLogs,
            ),
            Space.md(),
          ],
          floating: true,
          pinned: MediaQuery.of(context).size.height > 600,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (filteredLogs.isEmpty)
          const SliverFillRemaining(child: Center(child: Text('No logs found')))
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _LogTile(filteredLogs[index], key: ObjectKey(filteredLogs[index])),
                childCount: filteredLogs.length,
              ),
            ),
          ),
      ],
    ),
  );
}

/// {@template logs_screen}
/// _LogTile widget.
/// {@endtemplate}
class _LogTile extends StatelessWidget {
  /// {@macro logs_screen}
  const _LogTile(this.log, {super.key});

  final LogMessage log;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(
        title: Text(log.message.toString()),
        subtitle: Text(log.timestamp.format()),
        leading: _LogIcon(log.level),
        dense: true,
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () => Clipboard.setData(
            ClipboardData(
              text: switch (log) {
                LogMessageError log => '${log.message}\n${log.stackTrace}',
                _ => '${log.message}',
              },
            ),
          ),
        ),
      ),
      const Divider(height: 1),
    ],
  );
}

class _LogIcon extends StatelessWidget {
  const _LogIcon(this.level);

  final LogLevel level;

  @override
  Widget build(BuildContext context) => level.when<Widget>(
    debug: () => const Icon(Icons.bug_report, color: Colors.indigo),
    info: () => const Icon(Icons.info, color: Colors.blue),
    warning: () => const Icon(Icons.warning, color: Colors.orange),
    error: () => const Icon(Icons.error, color: Colors.red),
    shout: () => const Icon(Icons.campaign, color: Colors.red),
    v: () => const Icon(Icons.looks_one, color: Colors.grey),
    vv: () => const Icon(Icons.looks_two, color: Colors.grey),
    vvv: () => const Icon(Icons.looks_3, color: Colors.grey),
    vvvv: () => const Icon(Icons.looks_4, color: Colors.grey),
    vvvvv: () => const Icon(Icons.looks_5, color: Colors.grey),
    vvvvvv: () => const Icon(Icons.looks_6, color: Colors.grey),
  );
}
