import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:novaforge_starter/src/feature/developer/widget/developer_button.dart';
import 'package:novaforge_starter/src/feature/settings/widget/settings_button.dart';

/// {@template common_actions}
/// CommonActions is a list of common actions used in the app for the app bar.
/// {@endtemplate}
class CommonActions extends ListBase<Widget> {
  CommonActions([List<Widget>? actions])
    : _actions = <Widget>[
        ...?actions,
        if (kDebugMode) const DeveloperButton(),
        const SettingsButton(),
      ];

  final List<Widget> _actions;

  @override
  int get length => _actions.length;

  @override
  set length(int newLength) => _actions.length = newLength;

  @override
  Widget operator [](int index) => _actions[index];

  @override
  void operator []=(int index, Widget value) => _actions[index] = value;
}
