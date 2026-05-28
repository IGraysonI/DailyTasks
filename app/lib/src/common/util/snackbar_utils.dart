import 'package:flutter/material.dart';

/// {@template snackbar_utils}
/// Utils class for working with Snackbars.
/// {@endtemplate}
class SnackbarUtils {
  /// {@macro snackbar_utils}
  SnackbarUtils._();

  /// Show a SnackBar with the given [snackbar] in the [context].
  static void showSnackBar(BuildContext context, SnackBar snackbar) => ScaffoldMessenger.maybeOf(context)
    ?..removeCurrentSnackBar()
    ..showSnackBar(snackbar);
}
