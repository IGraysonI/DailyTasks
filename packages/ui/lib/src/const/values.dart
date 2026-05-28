const _contentBasePadding = 8.0;
const _sliverAppBarExpandedHigh = 95.0;
const _cardsCornerRadius = 12.0;
const _chipsCornerRadius = 20.0;
const _dialogCornerRadius = 28.0;

/// Class with getters for constant values
abstract class Values {
  const Values._();

  /// Base padding for widgets on pages
  static double get contentBasePadding => _contentBasePadding;

  /// Base durations for animations
  static ValuesDuration get duration => _valuesDuration;

  /// Radius of rounding corners on cards, except for the app bar, all corners should be
  /// rounded to the value of [_cardsCornerRadius]
  static double get cornerRadius => _cardsCornerRadius;

  /// Radius of rounding corners on circular chips
  /// rounded to the value of [_chipsCornerRadius]
  static double get chipRadius => _chipsCornerRadius;

  /// Radius of rounding corners for dialog windows
  static double get dialogRadius => _dialogCornerRadius;

  /// Radius of rounding corners for sliver app bar
  static double get sliverAppBarExpandedHigh => _sliverAppBarExpandedHigh;
}

const _valuesDuration = ValuesDuration._();

class ValuesDuration {
  const ValuesDuration._();

  int get fast => 250;
}
