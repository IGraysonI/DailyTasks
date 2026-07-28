import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:daily_tasks/src/common/util/snackbar_utils.dart';
import 'package:flutter/material.dart';

/// Utility for common state listener patterns.
final class StateListenerUtil {
  const StateListenerUtil._();

  /// Default state listener that handles errors by showing a snackbar.
  ///
  /// This listener:
  /// - Ignores processing states
  /// - Shows error snackbars when [next.error] is not null
  ///
  /// Use this as the default listener for [StateConsumer] widgets:
  /// ```dart
  /// StateConsumer<MyController, MyState>(
  ///   controller: controller,
  ///   listener: StateListenerUtil.defaultStateListener,
  ///   builder: (context, state, child) => MyWidget(),
  /// )
  /// ```
  ///
  /// Works with any state that extends [StateBase].
  static void defaultStateListener<S extends StateController<StateType>, StateType extends StateBase<StateType>>(
    BuildContext context,
    S controller,
    StateType prev,
    StateType next,
  ) {
    if (next.isProcessing) return;
    if (next.error != null) {
      SnackbarUtils.showSnackBar(
        context,
        SnackBar(
          content: Text(next.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
