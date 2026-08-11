import 'dart:async';

import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/controller_observer.dart';
import 'package:daily_tasks/src/common/model/app_metadata.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/log_buffer.dart';
import 'package:daily_tasks/src/common/util/screen_util.dart';
import 'package:daily_tasks/src/constants/pubspec.yaml.g.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/controller/daily_task_rewards_controller.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/data/daily_task_rewards_datasource.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/data/daily_task_rewards_repository.dart';
import 'package:daily_tasks/src/feature/daily_tasks/controller/daily_tasks_controller.dart';
import 'package:daily_tasks/src/feature/daily_tasks/data/daily_tasks_datasource.dart';
import 'package:daily_tasks/src/feature/daily_tasks/data/daily_tasks_repository.dart';
import 'package:daily_tasks/src/feature/daily_tasks/service/daily_tasks_reset_service.dart';
import 'package:daily_tasks/src/feature/initialization/platform/platform_initialization.dart';
import 'package:daily_tasks/src/feature/settings/controller/application_settings_controller.dart';
import 'package:daily_tasks/src/feature/settings/data/application_settings_datasource.dart';
import 'package:daily_tasks/src/feature/settings/data/application_settings_repository.dart';
import 'package:daily_tasks/src/feature/settings/model/application_settings.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/controller/weekly_task_rewards_controller.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/data/weekly_task_rewards_datasource.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/data/weekly_task_rewards_repository.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/controller/weekly_tasks_controller.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/data/weekly_tasks_datasource.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/data/weekly_tasks_repository.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/service/weekly_tasks_reset_service.dart';
import 'package:database/database.dart';
import 'package:l/l.dart';
import 'package:platform_info/platform_info.dart';
import 'package:rxdart/rxdart.dart';
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
  'Initialize daily tasks reset service': (dependencies) async =>
      dependencies.dailyTasksResetService = DailyTasksResetService(
        dailyTasksDatasource: DailyTasksDatasourceImpl(
          SqlDatabaseSource(dependencies.database),
          dependencies.sharedPreferences,
        ),
      ),
  'Prepare weekly tasks reset service': (dependencies) async =>
      dependencies.weeklyTasksResetService = WeeklyTasksResetService(
        weeklyTasksDatasource: WeeklyTasksDatasourceImpl(
          SqlDatabaseSource(dependencies.database),
          dependencies.sharedPreferences,
        ),
      ),
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
      applicationSettingsRepository: applicationSettingsRepository,
      initialState: initialState,
      dailyTasksResetService: dependencies.dailyTasksResetService,
      weeklyTasksResetService: dependencies.weeklyTasksResetService,
    )..fetchServiceStatuses(applicationSettings);
  },
  'Prepare daily tasks controller': (dependencies) => dependencies.dailyTasksController = DailyTasksController(
    dailyTasksRepository: DailyTasksRepositoryImpl(
      DailyTasksDatasourceImpl(
        SqlDatabaseSource(dependencies.database),
        dependencies.sharedPreferences,
      ),
    ),
  ),
  'Prepare daily task rewards controller': (dependencies) async {
    dependencies.dailyTaskRewardsController = DailyTaskRewardsController(
      dailyTaskRewardsRepository: DailyTaskRewardsRepositoryImpl(
        DailyTaskRewardsDatasourceImpl(SqlDatabaseSource(dependencies.database)),
      ),
    );
  },
  'Prepare weekly tasks controller': (dependencies) async {
    dependencies.weeklyTasksController = WeeklyTasksController(
      weeklyTasksRepository: WeeklyTasksRepositoryImpl(
        WeeklyTasksDatasourceImpl(
          SqlDatabaseSource(dependencies.database),
          dependencies.sharedPreferences,
        ),
      ),
    );
  },
  'Prepare weekly task rewards controller': (dependencies) async {
    dependencies.weeklyTaskRewardsController = WeeklyTaskRewardsController(
      weeklyTaskRewardsRepository: WeeklyTaskRewardsRepositoryImpl(
        WeeklyTaskRewardsDatasourceImpl(SqlDatabaseSource(dependencies.database)),
      ),
    );
  },
  'Collect logs': (dependencies) async {
    // TODO: Change log collection implementation (?)
    final sqlDatabaseSource = SqlDatabaseSource(dependencies.database);
    await sqlDatabaseSource
        .dao<LogsDao>()
        .getAllLogs()
        .then<List<LogMessage>>(
          (logs) => logs
              .map<LogMessage>(
                (l) => l.stackTrace != null
                    ? LogMessageError(
                        timestamp: l.timestamp,
                        level: LogLevel.fromValue(l.level),
                        message: l.message,
                        stackTrace: StackTrace.fromString(l.stackTrace!),
                      )
                    : LogMessageVerbose(
                        timestamp: l.timestamp,
                        level: LogLevel.fromValue(l.level),
                        message: l.message,
                      ),
              )
              .toList(growable: false),
        )
        .then<void>(LogBuffer.instance.addAll);
    l
        .bufferTime(const Duration(seconds: 1))
        .where((logs) => logs.isNotEmpty)
        .listen(LogBuffer.instance.addAll, cancelOnError: false);
    l
        .map<LogModel>(
          (log) => LogModel.create(
            level: log.level.level,
            message: log.message.toString(),
            timestamp: log.timestamp,
            stackTrace: switch (log) {
              LogMessageError l => l.stackTrace.toString(),
              _ => null,
            },
          ),
        )
        .bufferTime(const Duration(seconds: 5))
        .where((logs) => logs.isNotEmpty)
        .listen(
          (logs) => sqlDatabaseSource.dao<LogsDao>().insertAllLogs(logs),
          cancelOnError: false,
        );
  },
  'Log app initialized': (_) {},
};
