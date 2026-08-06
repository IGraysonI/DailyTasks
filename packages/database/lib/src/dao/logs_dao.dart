import 'package:database/database.dart';
import 'package:database/src/service/basic_dao.dart';

final class LogsDao extends BasicDao<Logs, Log, SqlDatabase> {
  LogsDao(super.db, {required super.companionType});

  @override
  TableInfo<Logs, Log> get table => db.logs;

  /// Get all tasks and return as a list of [LogModel]
  Future<List<LogModel>> getAllLogs() async {
    final logs =
        await (select(table)
              ..orderBy([(tbl) => OrderingTerm(expression: tbl.timestamp, mode: OrderingMode.desc)])
              ..limit(10000))
            .get();
    return logs.map(LogModel.fromTable).toList();
  }

  /// Get a log by [logId] and return as a [LogModel]
  Future<LogModel?> getLogById(int logId) async {
    final log = await (select(table)..where((tbl) => tbl.id.equals(logId))).getSingleOrNull();
    return log != null ? LogModel.fromTable(log) : null;
  }

  /// Insert a new log into the database
  Future<void> insertLog(LogModel logModel) async => await into(table).insert(
    LogsCompanion.insert(
      timestamp: logModel.timestamp,
      level: logModel.level,
      message: logModel.message,
      stackTrace: Value(logModel.stackTrace),
      createdAt: logModel.createdAt,
      updatedAt: logModel.updatedAt,
    ),
  );

  /// Insert multiple logs into the database
  Future<void> insertAllLogs(List<LogModel> logModels) async => batch((batch) {
    batch.insertAll(
      table,
      logModels.map(
        (logModel) => LogsCompanion.insert(
          timestamp: logModel.timestamp,
          level: logModel.level,
          message: logModel.message,
          stackTrace: Value(logModel.stackTrace),
          createdAt: logModel.createdAt,
          updatedAt: logModel.updatedAt,
        ),
      ),
    );
  }).ignore();

  /// Update a log in the database
  Future<void> updateLog(LogModel log) async => await update(table).replace(
    LogsCompanion(
      id: Value(log.id),
      timestamp: Value(log.timestamp),
      level: Value(log.level),
      message: Value(log.message),
      stackTrace: Value(log.stackTrace),
      createdAt: Value(log.createdAt),
      updatedAt: Value(log.updatedAt),
    ),
  );

  /// Delete a log from the database
  Future<void> deleteLog(int logId) async => await (delete(table)..where((tbl) => tbl.id.equals(logId))).go();

  /// Delete all logs from the database
  Future<void> deleteAllLogs() async => await delete(table).go();
}
