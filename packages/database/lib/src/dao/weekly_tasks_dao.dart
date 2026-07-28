import 'package:database/database.dart';
import 'package:database/src/service/basic_dao.dart';

final class WeeklyTasksDao extends BasicDao<WeeklyTasks, WeeklyTask, SqlDatabase> {
  WeeklyTasksDao(super.db, {required super.companionType});

  @override
  TableInfo<WeeklyTasks, WeeklyTask> get table => db.weeklyTasks;

  /// Get all tasks and return as a list of [WeeklyTaskModel]
  Future<List<WeeklyTaskModel>> getAllTasks() async {
    final tasks = await select(table).get();
    return tasks.map(WeeklyTaskModel.fromTable).toList();
  }

  /// Get a task by [taskId] and return as a [WeeklyTaskModel]
  Future<WeeklyTaskModel?> getTaskById(int taskId) async {
    final task = await (select(table)..where((tbl) => tbl.id.equals(taskId))).getSingleOrNull();
    return task != null ? WeeklyTaskModel.fromTable(task) : null;
  }

  /// Insert a new task into the database
  Future<void> insertTask(WeeklyTaskModel weeklyTaskModel) async => await into(table).insert(
    WeeklyTasksCompanion.insert(
      title: weeklyTaskModel.title,
      description: Value(weeklyTaskModel.description),
      weight: weeklyTaskModel.weight,
      isCompleted: Value(weeklyTaskModel.isCompleted),
      createdAt: weeklyTaskModel.createdAt,
      updatedAt: weeklyTaskModel.updatedAt,
    ),
  );

  /// Update a task in the database
  Future<void> updateTask(WeeklyTaskModel task) async => await update(table).replace(
    WeeklyTasksCompanion(
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
        const WeeklyTasksCompanion(isCompleted: Value(false)),
      );
}
