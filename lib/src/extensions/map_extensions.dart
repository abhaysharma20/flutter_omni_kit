/// Extensions for [Map].
extension MapExtensions<K, V> on Map<K, V> {
  /// Safely gets the value for [key]. Returns [defaultValue] if the key is not present.
  V getOrDefault(K key, V defaultValue) {
    return containsKey(key) ? this[key] as V : defaultValue;
  }

  /// Returns a new map containing only the key-value pairs that satisfy [test].
  Map<K, V> where(bool Function(K key, V value) test) {
    final result = <K, V>{};
    forEach((key, value) {
      if (test(key, value)) {
        result[key] = value;
      }
    });
    return result;
  }

  /// Returns a new map containing key-value pairs that do NOT satisfy [test].
  Map<K, V> whereNot(bool Function(K key, V value) test) {
    return where((key, value) => !test(key, value));
  }

  /// Transforms each key in the map using [transform].
  /// If multiple old keys map to the same new key, the last one wins.
  Map<R, V> mapKeys<R>(R Function(K key) transform) {
    final result = <R, V>{};
    forEach((key, value) {
      result[transform(key)] = value;
    });
    return result;
  }

  /// Transforms each value in the map using [transform].
  Map<K, R> mapValues<R>(R Function(V value) transform) {
    final result = <K, R>{};
    forEach((key, value) {
      result[key] = transform(value);
    });
    return result;
  }

  /// Flips keys and values. The values must be unique or data will be lost.
  Map<V, K> flip() {
    final result = <V, K>{};
    forEach((key, value) {
      result[value] = key;
    });
    return result;
  }

  /// Removes all keys that have a `null` value.
  Map<K, V> removeNullValues() {
    final result = <K, V>{};
    forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });
    return result;
  }

  /// Removes all keys that are present in the [keys] iterable.
  void removeAll(Iterable<K> keys) {
    for (final key in keys) {
      remove(key);
    }
  }

  /// Keeps only the keys that are present in the [keys] iterable.
  void retainAll(Iterable<K> keys) {
    final keysToRemove = this.keys.where((k) => !keys.contains(k)).toList();
    removeAll(keysToRemove);
  }

  /// Tries to parse the value at [key] as a [String]. Returns `null` if unable.
  String? getString(K key) {
    final value = this[key];
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  /// Tries to parse the value at [key] as an [int]. Returns `null` if unable.
  int? getInt(K key) {
    final value = this[key];
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Tries to parse the value at [key] as a [double]. Returns `null` if unable.
  double? getDouble(K key) {
    final value = this[key];
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Tries to parse the value at [key] as a [bool]. Returns `null` if unable.
  bool? getBool(K key) {
    final value = this[key];
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1' || lower == 'yes') return true;
      if (lower == 'false' || lower == '0' || lower == 'no') return false;
    }
    if (value is num) {
      if (value == 1) return true;
      if (value == 0) return false;
    }
    return null;
  }

  /// Gets a value from a nested map structure using a dotted path.
  /// Example: map.getDeep('user.address.city')
  dynamic getDeep(String path) {
    final keys = path.split('.');
    dynamic current = this;
    for (final key in keys) {
      if (current is Map) {
        current = current[key];
      } else {
        return null;
      }
    }
    return current;
  }
}
