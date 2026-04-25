/// Functional programming extensions for all Objects.
/// Similar to Kotlin's scoping functions (`let`, `also`, `run`, etc).
extension ObjectExtensions<T extends Object?> on T {
  /// Calls the specified function [block] with `this` value as its argument and returns its result.
  /// Useful for chaining operations or scoping variables.
  R let<R>(R Function(T it) block) {
    return block(this);
  }

  /// Calls the specified function [block] with `this` value as its argument and returns `this` value.
  /// Useful for side-effects like logging or initialization.
  T also(void Function(T it) block) {
    block(this);
    return this;
  }

  /// Returns `this` if it satisfies the given [predicate], otherwise returns `null`.
  T? takeIf(bool Function(T it) predicate) {
    if (predicate(this)) {
      return this;
    }
    return null;
  }

  /// Returns `this` if it *does not* satisfy the given [predicate], otherwise returns `null`.
  T? takeUnless(bool Function(T it) predicate) {
    if (!predicate(this)) {
      return this;
    }
    return null;
  }
}

/// Extensions specifically for nullable types.
extension NullableObjectExtensions<T extends Object> on T? {
  /// Returns `true` if the object is null.
  bool get isNull => this == null;

  /// Returns `true` if the object is not null.
  bool get isNotNull => this != null;

  /// Calls [onNull] if the object is null, otherwise returns the object.
  T orElse(T Function() onNull) {
    return this ?? onNull();
  }
}
