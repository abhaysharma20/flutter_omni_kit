import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A "one-liner" local storage solution using SharedPreferences.
class OmniStorage {
  static SharedPreferences? _prefs;

  /// Initialize the storage instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void _checkInit() {
    if (_prefs == null) {
      throw Exception(
          "OmniStorage not initialized. Call 'await OmniStorage.init()' first.");
    }
  }

  /// Save any primitive or JSON-encodable object
  static Future<bool> write(String key, dynamic value) async {
    _checkInit();
    if (value is String) return await _prefs!.setString(key, value);
    if (value is int) return await _prefs!.setInt(key, value);
    if (value is bool) return await _prefs!.setBool(key, value);
    if (value is double) return await _prefs!.setDouble(key, value);
    if (value is List<String>) return await _prefs!.setStringList(key, value);

    // For maps or custom objects, encode to JSON
    return await _prefs!.setString(key, jsonEncode(value));
  }

  /// Read a value from storage
  static T? read<T>(String key) {
    _checkInit();
    final value = _prefs!.get(key);
    if (value == null) return null;

    if (T == Map || T == List) {
      try {
        return jsonDecode(value as String) as T;
      } catch (_) {
        return null;
      }
    }

    return value as T;
  }

  /// Remove a key from storage
  static Future<bool> remove(String key) async {
    _checkInit();
    return await _prefs!.remove(key);
  }

  /// Clear all data
  static Future<bool> clear() async {
    _checkInit();
    return await _prefs!.clear();
  }
}
