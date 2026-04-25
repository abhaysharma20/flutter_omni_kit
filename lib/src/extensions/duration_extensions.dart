/// Extensions for the [Duration] class.
extension DurationExtensions on Duration {
  /// Returns the duration as a delayed [Future].
  Future<void> get delay => Future.delayed(this);

  /// Formats the duration as `HH:mm:ss`.
  /// E.g., 01:23:45
  String toHHMMSS() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60).abs());

    // Include hours even if it's 0, but handle negative durations properly.
    String hours = twoDigits(inHours.abs());
    String sign = isNegative ? "-" : "";
    return "$sign$hours:$twoDigitMinutes:$twoDigitSeconds";
  }

  /// Formats the duration as `mm:ss`.
  /// E.g., 23:45
  String toMMSS() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60).abs());

    String sign = isNegative ? "-" : "";

    // If it's over an hour, it includes hours in the minutes section (e.g. 65:30)
    int totalMins = inMinutes.abs();
    return "$sign${twoDigits(totalMins)}:$twoDigitSeconds";
  }

  /// Returns a human-readable representation of the duration.
  /// E.g., "2 hours", "1 minute", "30 seconds"
  String toReadableString() {
    if (inDays > 0) {
      return "$inDays ${inDays == 1 ? 'day' : 'days'}";
    }
    if (inHours > 0) {
      return "$inHours ${inHours == 1 ? 'hour' : 'hours'}";
    }
    if (inMinutes > 0) {
      return "$inMinutes ${inMinutes == 1 ? 'minute' : 'minutes'}";
    }
    if (inSeconds > 0) {
      return "$inSeconds ${inSeconds == 1 ? 'second' : 'seconds'}";
    }
    return "$inMilliseconds ms";
  }

  /// Adds this duration to the current [DateTime].
  DateTime get fromNow => DateTime.now().add(this);

  /// Subtracts this duration from the current [DateTime].
  DateTime get ago => DateTime.now().subtract(this);

  /// Returns `true` if the duration is exactly zero.
  bool get isZero => inMicroseconds == 0;

  /// Returns the absolute value of this duration.
  Duration get abs => isNegative ? -this : this;

  /// Adds the [other] duration.
  Duration plus(Duration other) => this + other;

  /// Subtracts the [other] duration.
  Duration minus(Duration other) => this - other;

  /// Multiplies the duration by the [factor].
  Duration multiply(num factor) {
    return Duration(microseconds: (inMicroseconds * factor).round());
  }

  /// Divides the duration by the [factor].
  Duration divide(num factor) {
    if (factor == 0) {
      throw ArgumentError.value(factor, "factor", "Cannot divide by zero");
    }
    return Duration(microseconds: (inMicroseconds / factor).round());
  }

  /// Returns the ratio of this duration to [other].
  double ratio(Duration other) {
    if (other.isZero) {
      throw ArgumentError.value(other, "other", "Cannot divide by zero duration");
    }
    return inMicroseconds / other.inMicroseconds;
  }
}
