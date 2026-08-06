import 'package:database/src/schema/base_schema.dart';

@DataClassName('Log', extending: BaseDataClass)
class Logs extends BaseSchema {
  @override
  String get tableName => 'Logs';

  DateTimeColumn get timestamp => dateTime()();

  /// Level is the severity level (a value between 0 and 6)
  IntColumn get level => integer()();

  TextColumn get message => text()();
}
