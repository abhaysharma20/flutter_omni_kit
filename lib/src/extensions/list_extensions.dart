/// Extensions for [List].
extension ListExtensions<T> on List<T> {
  /// Safely gets an element at [index]. Returns `null` if the index is out of bounds.
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Replaces the element at [index] with [newElement].
  /// Returns `true` if successful, `false` if the index is out of bounds.
  bool replaceAt(int index, T newElement) {
    if (index < 0 || index >= length) return false;
    this[index] = newElement;
    return true;
  }

  /// Replaces elements that satisfy the [test] predicate with [newElement].
  void replaceWhere(bool Function(T element) test, T newElement) {
    for (int i = 0; i < length; i++) {
      if (test(this[i])) {
        this[i] = newElement;
      }
    }
  }

  /// Removes duplicates from the list in-place based on the [selector].
  void removeDuplicatesBy<K>(K Function(T element) selector) {
    final seen = <K>{};
    retainWhere((element) => seen.add(selector(element)));
  }

  /// Returns a new list with elements sorted by [selector] in ascending order.
  List<T> sortedBy<K extends Comparable>(K Function(T element) selector) {
    final copy = toList();
    copy.sort((a, b) => selector(a).compareTo(selector(b)));
    return copy;
  }

  /// Returns a new list with elements sorted by [selector] in descending order.
  List<T> sortedByDescending<K extends Comparable>(
    K Function(T element) selector,
  ) {
    final copy = toList();
    copy.sort((a, b) => selector(b).compareTo(selector(a)));
    return copy;
  }

  /// Swaps the elements at [indexA] and [indexB].
  void swap(int indexA, int indexB) {
    final temp = this[indexA];
    this[indexA] = this[indexB];
    this[indexB] = temp;
  }

  /// Moves an element from [oldIndex] to [newIndex].
  void move(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= length) {
      throw RangeError.index(oldIndex, this);
    }
    if (newIndex < 0 || newIndex >= length) {
      throw RangeError.index(newIndex, this);
    }

    final item = removeAt(oldIndex);
    insert(newIndex, item);
  }

  /// Shifts all elements to the left by [count] positions.
  void shiftLeft([int count = 1]) {
    if (isEmpty) return;
    final normalizedCount = count % length;
    if (normalizedCount == 0) return;

    final head = sublist(0, normalizedCount);
    removeRange(0, normalizedCount);
    addAll(head);
  }

  /// Shifts all elements to the right by [count] positions.
  void shiftRight([int count = 1]) {
    if (isEmpty) return;
    final normalizedCount = count % length;
    if (normalizedCount == 0) return;

    final tail = sublist(length - normalizedCount);
    removeRange(length - normalizedCount, length);
    insertAll(0, tail);
  }

  /// Returns a random element from the list.
  /// Throws a [StateError] if the list is empty.
  T get random {
    if (isEmpty) throw StateError('Cannot get random element from empty list.');
    shuffle();
    return first;
  }

  /// Returns a paginated segment of the list.
  /// [page] is 1-indexed. Returns an empty list if page is out of bounds.
  List<T> getPage({required int page, required int pageSize}) {
    if (page < 1 || pageSize <= 0) return [];
    final start = (page - 1) * pageSize;
    if (start >= length) return [];
    final end = (start + pageSize > length) ? length : start + pageSize;
    return sublist(start, end);
  }

  /// Partitions the list into two lists:
  /// The first list contains elements that satisfy [test].
  /// The second list contains elements that do not.
  List<List<T>> partition(bool Function(T element) test) {
    final matches = <T>[];
    final nonMatches = <T>[];
    for (final element in this) {
      if (test(element)) {
        matches.add(element);
      } else {
        nonMatches.add(element);
      }
    }
    return [matches, nonMatches];
  }
}

/// Extensions for List of Lists.
extension FlattenListExtensions<T> on List<List<T>> {
  /// Flattens a nested list by one level.
  List<T> flatten() {
    return expand((element) => element).toList();
  }
}
