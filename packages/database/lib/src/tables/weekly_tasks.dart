import 'package:database/src/schema/base_schema.dart';

@DataClassName('WeeklyTask', extending: BaseDataClass)
class WeeklyTasks extends BaseSchema {
  @override
  String get tableName => 'WeeklyTasks';

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  IntColumn get weight => integer()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
