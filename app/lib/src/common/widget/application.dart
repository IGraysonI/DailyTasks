import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:novaforge_starter/src/common/router/router_state_mixin.dart';
import 'package:novaforge_starter/src/common/widget/window_scope.dart';
import 'package:novaforge_starter/src/feature/settings/widget/application_settings_scope.dart';
import 'package:octopus/octopus.dart';

/// {@template app}
/// App widget.
/// {@endtemplate}
class Application extends StatefulWidget {
  /// {@macro app}
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> with RouterStateMixin {
  final Key builderKey = GlobalKey(); // Disable recreate widget tree

  @override
  Widget build(BuildContext context) {
    final applicationSettings = ApplicationSettingsScope.settingsOf(context);
    final locale = applicationSettings.locale;
    final theme = applicationSettings.applicationTheme;
    final lightTheme = theme?.buildThemeData(Brightness.light);
    final darkTheme = theme?.buildThemeData(Brightness.dark);
    final themeMode = theme?.themeMode;
    return MaterialApp.router(
      title: 'NovaForge Starter',
      // debugShowCheckedModeBanner: !Config.environment.isProduction,
      debugShowCheckedModeBanner: false,

      // Router
      routerConfig: router.config,

      // Localizations
      localizationsDelegates: const <LocalizationsDelegate<Object?>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        Sheet1Localization.delegate,
      ],
      supportedLocales: Sheet1Localization.supportedLocales,
      // locale: SettingsScope.localOf(context),
      locale: locale,

      // Theme
      // theme: SettingsScope.themeOf(context),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      // Scopes
      builder: (context, child) => MediaQuery(
        key: builderKey,
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: WindowScope(
          title: Sheet1Localization.of(context).title,
          child: OctopusTools(
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
