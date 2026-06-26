import 'package:database/src/schema/base_schema.dart';

@DataClassName('WeeklyTaskReward', extending: BaseDataClass)
class WeeklyTaskRewards extends BaseSchema {
  @override
  String get tableName => 'WeeklyTaskRewards';

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  IntColumn get goalWeight => integer()();
}
