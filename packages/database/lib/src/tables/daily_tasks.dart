import 'package:database/src/schema/base_schema.dart';

@DataClassName('DailyTask', extending: BaseDataClass)
class DailyTasks extends BaseSchema {
  @override
  String get tableName => 'DailyTasks';

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  IntColumn get weight => integer()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
