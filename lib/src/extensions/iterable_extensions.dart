/// Extensions for [Iterable].
extension IterableExtensions<T> on Iterable<T> {
  /// Returns the first element that satisfies [test], or `null` if none found.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the last element that satisfies [test], or `null` if none found.
  T? lastWhereOrNull(bool Function(T element) test) {
    T? result;
    for (var element in this) {
      if (test(element)) result = element;
    }
    return result;
  }

  /// Returns a new Iterable with all elements sorted by [keySelector].
  Iterable<T> sortedBy(
    Comparable Function(T element) keySelector, {
    bool descending = false,
  }) {
    final list = toList();
    if (descending) {
      list.sort((a, b) => keySelector(b).compareTo(keySelector(a)));
    } else {
      list.sort((a, b) => keySelector(a).compareTo(keySelector(b)));
    }
    return list;
  }

  /// Returns a new Iterable containing only distinct elements, using [selector] to determine uniqueness.
  Iterable<T> distinctBy<R>(R Function(T element) selector) {
    final set = <R>{};
    final list = <T>[];
    for (var element in this) {
      final key = selector(element);
      if (set.add(key)) {
        list.add(element);
      }
    }
    return list;
  }

  /// Groups elements by the key returned by [keySelector].
  Map<K, List<T>> groupBy<K>(K Function(T element) keySelector) {
    final map = <K, List<T>>{};
    for (var element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Sums the values returned by [selector] for all elements.
  num sumBy(num Function(T element) selector) {
    num sum = 0;
    for (var element in this) {
      sum += selector(element);
    }
    return sum;
  }

  /// Returns the minimum element according to [selector], or `null` if empty.
  T? minBy(Comparable Function(T element) selector) {
    if (isEmpty) return null;
    var minElement = first;
    var minValue = selector(minElement);
    for (var element in skip(1)) {
      final value = selector(element);
      if (value.compareTo(minValue) < 0) {
        minElement = element;
        minValue = value;
      }
    }
    return minElement;
  }

  /// Returns the maximum element according to [selector], or `null` if empty.
  T? maxBy(Comparable Function(T element) selector) {
    if (isEmpty) return null;
    var maxElement = first;
    var maxValue = selector(maxElement);
    for (var element in skip(1)) {
      final value = selector(element);
      if (value.compareTo(maxValue) > 0) {
        maxElement = element;
        maxValue = value;
      }
    }
    return maxElement;
  }

  /// Counts the number of elements that satisfy [test].
  int countWhere(bool Function(T element) test) {
    int count = 0;
    for (var element in this) {
      if (test(element)) count++;
    }
    return count;
  }

  /// Yields pairs of (index, element).
  Iterable<MapEntry<int, T>> get indexed sync* {
    var index = 0;
    for (var element in this) {
      yield MapEntry(index++, element);
    }
  }

  /// Splits the iterable into chunks of size [size].
  Iterable<List<T>> chunked(int size) sync* {
    if (size <= 0) throw ArgumentError('size must be > 0');
    var iterator = this.iterator;
    while (iterator.moveNext()) {
      var chunk = <T>[iterator.current];
      for (var i = 1; i < size && iterator.moveNext(); i++) {
        chunk.add(iterator.current);
      }
      yield chunk;
    }
  }

  /// Maps the iterable with the index of each element.
  Iterable<R> mapIndexed<R>(R Function(int index, T element) transform) sync* {
    var index = 0;
    for (var element in this) {
      yield transform(index++, element);
    }
  }

  /// Returns `true` if all elements satisfy [test] or if the iterable is empty.
  bool all(bool Function(T element) test) {
    for (var element in this) {
      if (!test(element)) return false;
    }
    return true;
  }

  /// Returns `true` if at least one element satisfies [test].
  bool any(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return true;
    }
    return false;
  }

  /// Returns `true` if no elements satisfy [test].
  bool none(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return false;
    }
    return true;
  }
}

/// Extensions for nullable Iterable.
extension NullableIterableExtensions<T> on Iterable<T>? {
  /// Returns `true` if the iterable is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns `true` if the iterable is not null and not empty.
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
}

/// Extension for Iterable of numbers.
extension NumIterableExtensions<T extends num> on Iterable<T> {
  /// Returns the sum of all numbers in the iterable.
  num sum() {
    num total = 0;
    for (var element in this) {
      total += element;
    }
    return total;
  }

  /// Returns the average of all numbers in the iterable, or 0 if empty.
  double average() {
    if (isEmpty) return 0.0;
    return sum() / length;
  }

  /// Returns the maximum value, or null if empty.
  T? max() {
    if (isEmpty) return null;
    return reduce((a, b) => a > b ? a : b);
  }

  /// Returns the minimum value, or null if empty.
  T? min() {
    if (isEmpty) return null;
    return reduce((a, b) => a < b ? a : b);
  }
}
