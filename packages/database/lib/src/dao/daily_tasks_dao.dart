import 'package:database/database.dart';
import 'package:database/src/service/basic_dao.dart';

final class DailyTaskDao extends BasicDao<DailyTasks, DailyTask, SqlDatabase> {
  DailyTaskDao(super.db, {required super.companionType});

  @override
  TableInfo<DailyTasks, DailyTask> get table => db.dailyTasks;

  /// Get all tasks and return as a list of [DailyTaskModel]
  Future<List<DailyTaskModel>> getAllTasks() async {
    final tasks = await select(table).get();
    return tasks.map(DailyTaskModel.fromTable).toList();
  }

  /// Get a task by [taskId] and return as a [DailyTaskModel]
  Future<DailyTaskModel?> getTaskById(String taskId) async {
    final task = await (select(table)..where((tbl) => tbl.id.equals(taskId))).getSingleOrNull();
    return task != null ? DailyTaskModel.fromTable(task) : null;
  }

  /// Insert a new task into the database
  Future<void> insertTask(DailyTaskModel dailyTaskModel) async => await into(table).insert(
    DailyTasksCompanion.insert(
      title: dailyTaskModel.title,
      description: Value(dailyTaskModel.description),
      weight: dailyTaskModel.weight,
      isCompleted: Value(dailyTaskModel.isCompleted),
      createdAt: dailyTaskModel.createdAt,
      updatedAt: dailyTaskModel.updatedAt,
    ),
  );

  /// Update a task in the database
  Future<void> updateTask(DailyTaskModel task) async => await update(table).replace(
    DailyTasksCompanion.insert(
      id: Value(task.id),
      title: task.title,
      description: Value(task.description),
      weight: task.weight,
      isCompleted: Value(task.isCompleted),
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    ),
  );

  /// Delete a task from the database
  Future<void> deleteTask(String taskId) async => await (delete(table)..where((tbl) => tbl.id.equals(taskId))).go();

  /// Delete all tasks from the database
  Future<void> deleteAllTasks() async => await delete(table).go();

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    final task = await getTaskById(id);
    if (task == null) return;
    await updateTask(task.copyWith(isCompleted: !task.isCompleted));
  }
}
