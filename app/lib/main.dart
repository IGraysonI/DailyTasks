import 'package:flutter/material.dart';
import 'package:novaforge_starter/src/common/util/app_zone.dart';
import 'package:novaforge_starter/src/common/util/error_util.dart';
import 'package:novaforge_starter/src/common/widget/application.dart';
import 'package:novaforge_starter/src/common/widget/application_error.dart' deferred as app_error;
import 'package:novaforge_starter/src/feature/initialization/initialization.dart' deferred as initialization;
import 'package:novaforge_starter/src/feature/settings/widget/application_settings_scope.dart';
import 'package:octopus/octopus.dart';
import 'package:platform_info/platform_info.dart';

void main() => appZone(() async {
  final initializationProgress = ValueNotifier<({int progress, String message})>((progress: 0, message: ''));
  await initialization.loadLibrary();
  await initialization.$initializeApp(
    onProgress: (progress, message) => initializationProgress.value = (progress: progress, message: message),
    onSuccess: (dependencies) async => runApp(
      dependencies.inject(
        child: ApplicationSettingsScope(
          child: NoAnimationScope(
            noAnimation: platform.js || platform.desktop,
            child: const Application(),
          ),
        ),
      ),
    ),
    onError: (error, stackTrace) async {
      await app_error.loadLibrary();
      runApp(app_error.ApplicationError(error: error));
      ErrorUtil.logError(error, stackTrace).ignore();
    },
  );
});
