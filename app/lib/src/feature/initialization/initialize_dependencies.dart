import 'dart:async';

import 'package:control/control.dart';
import 'package:database/database.dart';
import 'package:l/l.dart';
import 'package:novaforge_starter/src/common/controller/controller_observer.dart';
import 'package:novaforge_starter/src/common/model/app_metadata.dart';
import 'package:novaforge_starter/src/common/model/dependencies.dart';
import 'package:novaforge_starter/src/common/util/screen_util.dart';
import 'package:novaforge_starter/src/constants/pubspec.yaml.g.dart';
import 'package:novaforge_starter/src/feature/initialization/platform/platform_initialization.dart';
import 'package:novaforge_starter/src/feature/settings/controller/application_settings_controller.dart';
import 'package:novaforge_starter/src/feature/settings/data/application_settings_datasource.dart';
import 'package:novaforge_starter/src/feature/settings/data/application_settings_repository.dart';
import 'package:novaforge_starter/src/feature/settings/model/application_settings.dart';
import 'package:platform_info/platform_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef _InitializationStep = FutureOr<void> Function(Dependencies dependencies);

/// Initializes the app and returns a [Dependencies] object
Future<Dependencies> $initializeDependencies({void Function(int progress, String message)? onProgress}) async {
  final dependencies = Dependencies();
  final totalSteps = _initializationSteps.length;
  var currentStep = 0;
  for (final step in _initializationSteps.entries) {
    try {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      onProgress?.call(percent, step.key);
      l.v6('Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
      await step.value(dependencies);
    } on Object catch (error, stackTrace) {
      l.e('Initialization failed at step "${step.key}": $error', stackTrace);
      Error.throwWithStackTrace('Initialization failed at step "${step.key}": $error', stackTrace);
    }
  }
  return dependencies;
}

final Map<String, _InitializationStep> _initializationSteps = <String, _InitializationStep>{
  'Platform pre-initialization': (_) => $platformInitialization(),
  'Creating app metadata': (dependencies) => dependencies.appMetadata = AppMetadata(
    isWeb: platform.js,
    isRelease: platform.buildMode.release,
    appName: Pubspec.name,
    appVersion: Pubspec.version.representation,
    appVersionMajor: Pubspec.version.major,
    appVersionMinor: Pubspec.version.minor,
    appVersionPatch: Pubspec.version.patch,
    appBuildTimestamp: Pubspec.version.build.isNotEmpty
        ? (int.tryParse(Pubspec.version.build.firstOrNull ?? '-1') ?? -1)
        : -1,
    operatingSystem: platform.operatingSystem.name,
    processorsCount: platform.numberOfProcessors,
    appLaunchedTimestamp: DateTime.now(),
    locale: platform.locale,
    deviceVersion: platform.version,
    deviceScreenSize: ScreenUtil.screenSize().representation,
  ),
  'Observer state managment': (_) => Controller.observer = const ControllerObserver(),
  'Initializing analytics': (_) {},
  'Log app open': (_) {},
  'Get remote config': (_) {},
  'Restore settings': (_) {},
  'Initialize shared preferences': (dependencies) async =>
      dependencies.sharedPreferences = await SharedPreferences.getInstance(),
  'Connect to database': (dependencies) async =>
      // (dependencies.database = Config.inMemoryDatabase ? Database.memory() : Database.lazy()).refresh(),
      dependencies.database = SqlDatabase.defaults(),
  'Shrink database': (dependencies) async {
    // TODO: Implement database shrinking
    // await dependencies.database.customStatement('VACUUM;');
    // await dependencies.database.transaction(() async {
    //   final log =
    //       await (dependencies.database.select<LogTbl, LogTblData>(dependencies.database.logTbl)
    //             ..orderBy([(tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.desc)])
    //             ..limit(1, offset: 1000))
    //           .getSingleOrNull();
    //   if (log != null) {
    //     await (dependencies.database.delete(
    //       dependencies.database.logTbl,
    //     )..where((tbl) => tbl.time.isSmallerOrEqualValue(log.time))).go();
    //   }
    // });
    // if (DateTime.now().second % 10 == 0) await dependencies.database.customStatement('VACUUM;');
  },
  // 'Migrate app from previous version': (dependencies) => AppMigrator.migrate(dependencies.database),
  'Prepare application settings controller': (dependencies) async {
    final applicationSettingsRepository = ApplicationSettingsRepositoryImpl(
      ApplicationSettingsDatasourceImpl(dependencies.sharedPreferences),
    );
    ApplicationSettings? applicationSettings;
    applicationSettings = await applicationSettingsRepository.getApplicationSettings();
    if (applicationSettings == null) {
      const defaultApplicationSettings = ApplicationSettings.defaultSettings;
      await applicationSettingsRepository.setApplicationSettings(defaultApplicationSettings);
      applicationSettings = defaultApplicationSettings;
    }
    final initialState = ApplicationSettingsState.idle(applicationSettings: applicationSettings);
    dependencies.applicationSettingsController = ApplicationSettingsController(
      applicaitonSettingsRepository: applicationSettingsRepository,
      initialState: initialState,
    );
  },
  'Collect logs': (dependencies) async {
    // TODO: Implement log collection
    //   await (dependencies.database.select<LogTbl, LogTblData>(dependencies.database.logTbl)
    //         ..orderBy([(tbl) => OrderingTerm(expression: tbl.time, mode: OrderingMode.desc)])
    //         ..limit(LogBuffer.bufferLimit))
    //       .get()
    //       .then<List<LogMessage>>(
    //         (logs) => logs
    //             .map<LogMessage>(
    //               (l) => l.stack != null
    //                   ? LogMessageError(
    //                       timestamp: DateTime.fromMillisecondsSinceEpoch(l.time * 1000),
    //                       level: LogLevel.fromValue(l.level),
    //                       message: l.message,
    //                       stackTrace: StackTrace.fromString(l.stack!),
    //                     )
    //                   : LogMessageVerbose(
    //                       timestamp: DateTime.fromMillisecondsSinceEpoch(l.time * 1000),
    //                       level: LogLevel.fromValue(l.level),
    //                       message: l.message,
    //                     ),
    //             )
    //             .toList(growable: false),
    //       )
    //       .then<void>(LogBuffer.instance.addAll);
    //   l
    //       .bufferTime(const Duration(seconds: 1))
    //       .where((logs) => logs.isNotEmpty)
    //       .listen(LogBuffer.instance.addAll, cancelOnError: false);
    //   l
    //       .map<LogTblCompanion>(
    //         (log) => LogTblCompanion.insert(
    //           level: log.level.level,
    //           message: log.message.toString(),
    //           time: Value<int>(log.timestamp.millisecondsSinceEpoch ~/ 1000),
    //           stack: Value<String?>(switch (log) {
    //             LogMessageError l => l.stackTrace.toString(),
    //             _ => null,
    //           }),
    //         ),
    //       )
    //       .bufferTime(const Duration(seconds: 5))
    //       .where((logs) => logs.isNotEmpty)
    //       .listen(
    //         (logs) =>
    //             dependencies.database.batch((batch) => batch.insertAll(dependencies.database.logTbl, logs)).ignore(),
    //         cancelOnError: false,
    //       );
  },
  'Log app initialized': (_) {},
};
