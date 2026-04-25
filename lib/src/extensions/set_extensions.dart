/// Extensions for [Set].
extension SetExtensions<T> on Set<T> {
  /// Toggles the presence of [element] in the set.
  /// If it exists, it is removed. If it doesn't exist, it is added.
  /// Returns `true` if the element was added, `false` if it was removed.
  bool toggle(T element) {
    if (contains(element)) {
      remove(element);
      return false;
    } else {
      add(element);
      return true;
    }
  }

  /// Returns a new set containing elements that are in this set but not in [other].
  Set<T> operator -(Set<T> other) => difference(other);

  /// Returns a new set containing all elements from both sets.
  Set<T> operator +(Set<T> other) => union(other);

  /// Returns `true` if this set and [other] contain exactly the same elements.
  bool isEquivalentTo(Set<T> other) {
    if (length != other.length) return false;
    return containsAll(other);
  }

  /// Returns a new set containing only the elements that are not shared between this and [other] (Symmetric Difference).
  Set<T> symmetricDifference(Set<T> other) {
    final diff1 = difference(other);
    final diff2 = other.difference(this);
    return diff1.union(diff2);
  }

  /// Maps elements using [transform] and returns a new Set.
  Set<R> mapToSet<R>(R Function(T element) transform) {
    return map(transform).toSet();
  }

  /// Returns a new set containing only elements that are not null.
  Set<T> whereNotNull() {
    return where((e) => e != null).toSet();
  }
}
