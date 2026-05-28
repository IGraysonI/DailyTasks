import 'package:flutter/widgets.dart' show DefaultTransitionDelegate, State, StatefulWidget, ValueNotifier;
import 'package:novaforge_starter/src/common/router/home_guard.dart';
import 'package:novaforge_starter/src/common/router/routes.dart';
import 'package:octopus/octopus.dart';

/// {@template router_state_mixin}
/// A mixin that provides a [router] and [errorsObserver] to the MaterialApp.
/// {@endtemplate}
mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  /// The router instance.
  late final Octopus router;

  /// The observer for errors.
  late final ValueNotifier<List<({Object error, StackTrace stackTrace})>> errorsObserver;

  @override
  void initState() {
    // Observe all errors.
    errorsObserver = ValueNotifier<List<({Object error, StackTrace stackTrace})>>(
      <({Object error, StackTrace stackTrace})>[],
    );
    // Create router.
    router = Octopus(
      routes: Routes.values,
      defaultRoute: Routes.home,
      transitionDelegate: const DefaultTransitionDelegate(),
      guards: <IOctopusGuard>[
        // Home route should be always on top.
        HomeGuard(),
      ],
      onError: (error, stackTrace) => errorsObserver.value = <({Object error, StackTrace stackTrace})>[
        (error: error, stackTrace: stackTrace),
        ...errorsObserver.value,
      ],
    );
    super.initState();
  }
}
