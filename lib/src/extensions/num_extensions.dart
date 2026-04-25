import 'dart:math' as math;

/// Extensions for [num] (both [int] and [double]).
extension NumExtensions on num {
  /// Ensures the number is between [min] and [max] (inclusive).
  num clamp(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Returns `true` if the number is between [min] and [max] (inclusive).
  bool isBetween(num min, num max) => this >= min && this <= max;

  /// Returns `true` if the number is between [min] and [max] (exclusive).
  bool isBetweenExclusive(num min, num max) => this > min && this < max;

  /// Returns a formatted currency string (e.g. `$1,234.56`).
  /// Note: A basic implementation. For i18n, use `intl` package.
  String toCurrency({String symbol = '\$', int decimalDigits = 2}) {
    String formatted = toStringAsFixed(decimalDigits);
    final parts = formatted.split('.');
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    parts[0] = parts[0].replaceAllMapped(reg, (Match match) => '${match[1]},');
    return '$symbol${parts.join('.')}';
  }

  /// Formats the number as a compact representation (e.g., 1.2K, 3.4M).
  String toCompact() {
    if (this < 1000) return toStringAsFixed(0);
    if (this < 1000000) {
      return '${(this / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K';
    }
    if (this < 1000000000) {
      return '${(this / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
    }
    return '${(this / 1000000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}B';
  }

  /// Calculates the percentage of this number out of [total].
  double percentageOf(num total) {
    if (total == 0) return 0.0;
    return (this / total) * 100;
  }

  /// Scales this number from one range to another.
  /// Example: 5.scale(0, 10, 0, 100) -> 50
  double scale(num fromMin, num fromMax, num toMin, num toMax) {
    return ((this - fromMin) / (fromMax - fromMin)) * (toMax - toMin) + toMin;
  }

  /// Converts degrees to radians.
  double get toRadians => this * (math.pi / 180.0);

  /// Converts radians to degrees.
  double get toDegrees => this * (180.0 / math.pi);

  /// Rounds to a specified number of decimal places.
  double roundTo(int places) {
    num mod = math.pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }

  /// Returns the square of this number.
  num get squared => this * this;

  /// Returns the cube of this number.
  num get cubed => this * this * this;
}

/// Extensions for [int] specifically.
extension IntExtensions on int {
  /// Converts this integer to a [Duration] in milliseconds.
  Duration get milliseconds => Duration(milliseconds: this);

  /// Converts this integer to a [Duration] in seconds.
  Duration get seconds => Duration(seconds: this);

  /// Converts this integer to a [Duration] in minutes.
  Duration get minutes => Duration(minutes: this);

  /// Converts this integer to a [Duration] in hours.
  Duration get hours => Duration(hours: this);

  /// Converts this integer to a [Duration] in days.
  Duration get days => Duration(days: this);

  /// Returns a list of integers from 0 to [this] - 1.
  /// E.g. 3.range -> [0, 1, 2]
  List<int> get range => List<int>.generate(this, (i) => i);

  /// Executes [action] `this` number of times.
  void times(void Function(int index) action) {
    for (int i = 0; i < this; i++) {
      action(i);
    }
  }

  /// Returns true if the integer is even.
  bool get isEven => this % 2 == 0;

  /// Returns true if the integer is odd.
  bool get isOdd => this % 2 != 0;
}

/// Extensions for nullable numbers.
extension NullableNumExtensions on num? {
  /// Returns `this` or 0 if null.
  num get orZero => this ?? 0;

  /// Returns `true` if the number is null or exactly zero.
  bool get isNullOrZero => this == null || this == 0;
}
