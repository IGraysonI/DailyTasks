import 'package:drift/drift.dart';

export 'package:drift/drift.dart';

/// Type for identificators in the database
/// if you want to change it, change it here
typedef IdentificatorType = int;

/// Drfit column type for identificators
/// use [IdentificatorType] to change it
typedef IdentificatorColumn = Column<IdentificatorType>;

/// {@template base_schema}
/// Base schema for all database tables
/// {@endtemplate}
abstract class BaseSchema extends Table {
  /// table name must be overridden in each table
  @override
  String get tableName;

  /// Unique identificator column for each record, auto incremented
  IdentificatorColumn get id => integer().autoIncrement().nullable()();

  /// Date of creation of the record
  DateTimeColumn get createdAt => dateTime()();

  ///  Date of last update of the record
  DateTimeColumn get updatedAt => dateTime()();

  /// Date of creation of the record on the mobile device (local timestamp).
  DateTimeColumn get localCreatedAt => dateTime().clientDefault(DateTime.now).nullable()();

  /// Mark record for deletion, default is false
  /// See soft delete pattern
  BoolColumn get isDeleted => boolean().nullable().clientDefault(() => false)();
}

/// {@template base_data_class}
/// Base data class for all database tables
/// {@endtemplate}
abstract class BaseDataClass extends DataClass {
  abstract final IdentificatorType? id;
  abstract final DateTime? createdAt;
  abstract final DateTime? updatedAt;
  abstract final DateTime? localCreatedAt;
  abstract final bool? isDeleted;

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'localCreatedAt': serializer.toJson<DateTime?>(localCreatedAt),
      'isDeleted': serializer.toJson<bool?>(isDeleted),
    };
  }
}
