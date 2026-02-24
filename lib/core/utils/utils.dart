/// Convenience `DateTime` helpers shared across the app.
extension DateTimeExtension on DateTime {
  /// Returns the same date truncated to year-month-day.
  DateTime get onlyDate => .new(year, month, day);
}
