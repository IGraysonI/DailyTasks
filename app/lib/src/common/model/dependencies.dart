import 'package:database/database.dart';
import 'package:flutter/widgets.dart';
import 'package:novaforge_starter/src/common/model/app_metadata.dart';
import 'package:novaforge_starter/src/feature/settings/controller/application_settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template dependencies}
/// Application dependencies.
/// {@endtemplate}
class Dependencies {
  /// {@macro dependencies}
  Dependencies();

  /// The state from the closest instance of this class.
  ///
  /// {@macro dependencies}
  factory Dependencies.of(BuildContext context) => InheritedDependencies.of(context);

  /// Injest dependencies to the widget tree.
  Widget inject({required Widget child, Key? key}) => InheritedDependencies(dependencies: this, key: key, child: child);

  /// App metadata
  late final AppMetadata appMetadata;

  /// Shared preferences
  late final SharedPreferences sharedPreferences;

  /// Sql database
  late final SqlDatabase database;

  /// Application Settings Controller
  late final ApplicationSettingsController applicationSettingsController;

  @override
  String toString() => 'Dependencies{}';
}

/// Fake Dependencies
@visibleForTesting
class FakeDependencies extends Dependencies {
  FakeDependencies();

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// {@template inherited_dependencies}
/// InheritedDependencies widget.
/// {@endtemplate}
class InheritedDependencies extends InheritedWidget {
  /// {@macro inherited_dependencies}
  const InheritedDependencies({required this.dependencies, required super.child, super.key});

  final Dependencies dependencies;

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  static Dependencies? maybeOf(BuildContext context) =>
      (context.getElementForInheritedWidgetOfExactType<InheritedDependencies>()?.widget as InheritedDependencies?)
          ?.dependencies;

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
    'Out of scope, not found inherited widget '
        'a InheritedDependencies of the exact type',
    'out_of_scope',
  );

  /// The state from the closest instance of this class
  /// that encloses the given context.
  static Dependencies of(BuildContext context) => maybeOf(context) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant InheritedDependencies oldWidget) => false;
}
