import 'package:database/src/schema/base_schema.dart';

@DataClassName('DailyTaskReward', extending: BaseDataClass)
class DailyTaskRewards extends BaseSchema {
  @override
  String get tableName => 'DailyTaskRewards';

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  IntColumn get goalWeight => integer()();
}
