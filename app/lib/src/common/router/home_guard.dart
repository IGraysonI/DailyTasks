import 'dart:async';

import 'package:novaforge_starter/src/common/router/routes.dart';
import 'package:octopus/octopus.dart';

/// {@template home_guard}
/// Check routes always contain the home route at the first position.
/// {@endtemplate}
class HomeGuard extends OctopusGuard {
  /// {@macro home_guard}
  HomeGuard();

  static final String _homeName = Routes.home.name;

  @override
  Future<OctopusState> call(
    List<OctopusHistoryEntry> history,
    OctopusState$Mutable state,
    Map<String, Object?> context,
  ) async {
    // Home route should be the first route in the state
    // and should be only one in whole state.
    if (state.isEmpty) return _fix(state);
    final count = state.findAllByName(_homeName).length;
    if (count != 1) return _fix(state);
    if (state.children.first.name != _homeName) return _fix(state);
    return state;
  }

  /// Change the state of the nested navigation.
  OctopusState _fix(OctopusState$Mutable state) => state
    ..clear()
    ..putIfAbsent(_homeName, Routes.home.node);
}
