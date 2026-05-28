Future<void> $captureException(
  Object exception,
  StackTrace stackTrace,
  String? hint, {
  bool fatal = false,
}) => Future<void>.value(null);

Future<void> $captureMessage(
  String message,
  StackTrace? stackTrace,
  String? hint, {
  bool warning = false,
}) => Future<void>.value(null);
