import 'dart:async';

/// A utility class for debouncing execution of functions.
///
/// Useful for limiting the rate at which a function is executed,
/// such as searching as a user types, or handling rapid button presses.
class Debouncer {
  /// The duration to wait before executing the action.
  final Duration delay;

  Timer? _timer;

  /// Creates a [Debouncer] with the given [delay].
  Debouncer({required this.delay});

  /// Executes the given [action] after the [delay] has passed.
  /// If [run] is called again before the delay has passed, the previous
  /// action is cancelled and the timer is reset.
  void run(FutureOr<void> Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, () {
      action();
    });
  }

  /// Cancels any pending action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Checks if there is a pending action.
  bool get isPending => _timer?.isActive ?? false;
}
