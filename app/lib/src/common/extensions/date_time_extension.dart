/// {@template date_time_extension}
/// Collection of useful extensions for [DateTime].
/// {@endtemplate}
extension DateTimeExtension on DateTime {
  /// Returns a string representation of the date in the format 'dd.MM.yyyy'.
  String get dateOnly => '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year';
}
