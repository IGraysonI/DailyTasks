import 'package:database/database.dart';
import 'package:database/src/service/basic_dao.dart';

final class DailyTasksDao extends BasicDao<DailyTasks, DailyTask, SqlDatabase> {
  DailyTasksDao(super.db, {required super.companionType});

  @override
  TableInfo<DailyTasks, DailyTask> get table => db.dailyTasks;

  /// Get all tasks and return as a list of [DailyTaskModel]
  Future<List<DailyTaskModel>> getAllTasks() async {
    final tasks = await select(table).get();
    return tasks.map(DailyTaskModel.fromTable).toList();
  }

  /// Get a task by [taskId] and return as a [DailyTaskModel]
  Future<DailyTaskModel?> getTaskById(int taskId) async {
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
    DailyTasksCompanion(
      id: Value(task.id),
      title: Value(task.title),
      description: Value(task.description),
      weight: Value(task.weight),
      isCompleted: Value(task.isCompleted),
      createdAt: Value(task.createdAt),
      updatedAt: Value(task.updatedAt),
    ),
  );

  /// Delete a task from the database
  Future<void> deleteTask(int taskId) async => await (delete(table)..where((tbl) => tbl.id.equals(taskId))).go();

  /// Delete all tasks from the database
  Future<void> deleteAllTasks() async => await delete(table).go();

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(int taskId) async {
    final task = await getTaskById(taskId);
    if (task == null) return;
    await updateTask(
      task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Set all tasks as not completed on new day
  Future<void> resetTasksCompletions() async =>
      await (update(table)..where((tbl) => tbl.isCompleted.equals(true))).write(
        const DailyTasksCompanion(isCompleted: Value(false)),
      );
}
