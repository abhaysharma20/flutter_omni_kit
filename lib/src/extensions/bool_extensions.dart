/// Extensions for the [bool] class.
extension BoolExtensions on bool {
  /// Returns 1 if `true`, 0 if `false`.
  int toInt() => this ? 1 : 0;

  /// Returns 'Yes' if `true`, 'No' if `false`.
  String toYesNo() => this ? 'Yes' : 'No';

  /// Returns 'True' if `true`, 'False' if `false`.
  String toTrueFalse() => this ? 'True' : 'False';

  /// Returns 'On' if `true`, 'Off' if `false`.
  String toOnOff() => this ? 'On' : 'Off';

  /// Executes [action] if this boolean is `true`.
  void ifTrue(void Function() action) {
    if (this) {
      action();
    }
  }

  /// Executes [action] if this boolean is `false`.
  void ifFalse(void Function() action) {
    if (!this) {
      action();
    }
  }

  /// Returns [trueValue] if `true`, else returns [falseValue].
  T fold<T>({required T Function() isTrue, required T Function() isFalse}) {
    return this ? isTrue() : isFalse();
  }

  /// Returns `this` or [other] based on logical AND.
  bool and(bool other) => this && other;

  /// Returns `this` or [other] based on logical OR.
  bool or(bool other) => this || other;

  /// Returns the logical XOR of `this` and [other].
  bool xor(bool other) => this != other;

  /// Toggles the boolean value.
  bool toggle() => !this;
}

/// Extensions on nullable boolean [bool?].
extension NullableBoolExtensions on bool? {
  /// Returns `true` if the value is strictly `true`.
  /// Returns `false` if the value is `null` or `false`.
  bool get isTrue => this == true;

  /// Returns `true` if the value is strictly `false`.
  /// Returns `false` if the value is `null` or `true`.
  bool get isFalse => this == false;

  /// Returns `true` if the value is `null` or `true`.
  bool get isNullOrTrue => this == null || this == true;

  /// Returns `true` if the value is `null` or `false`.
  bool get isNullOrFalse => this == null || this == false;

  /// Toggles the value if not null. Defaults to [fallback] if null.
  bool toggleOr(bool fallback) => this != null ? !this! : fallback;

  /// Returns 1 if `true`, 0 if `false`, and [fallback] if `null`.
  int toIntOr(int fallback) => this == null ? fallback : (this! ? 1 : 0);
}
