/// The severity levels for the logger.
enum LogLevel {
  /// Detailed debug information
  debug,

  /// General information
  info,

  /// Warnings for non-critical issues
  warning,

  /// Errors for critical failures
  error,

  /// Completely disables logging
  none,
}

/// A simple, stylized console logger with multiple severity levels.
class Logger {
  Logger._();

  /// The current logging level. Any logs below this level will be ignored.
  static LogLevel level = LogLevel.debug;

  /// Whether to include timestamps in the output.
  static bool includeTimestamp = true;

  // ANSI escape codes for colors
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';

  static String _formatMessage(
    String levelName,
    String color,
    dynamic message,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    final buffer = StringBuffer();
    if (includeTimestamp) {
      final now = DateTime.now().toIso8601String();
      buffer.write('[$now] ');
    }
    buffer.write('$color[$levelName] $message$_reset');

    if (error != null) {
      buffer.write('\n$color$error$_reset');
    }
    if (stackTrace != null) {
      buffer.write('\n$color$stackTrace$_reset');
    }
    return buffer.toString();
  }

  /// Logs a debug message (Blue).
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (level.index > LogLevel.debug.index) return;
    print(_formatMessage('DEBUG', _blue, message, error, stackTrace));
  }

  /// Logs an info message (Green).
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (level.index > LogLevel.info.index) return;
    print(_formatMessage('INFO', _green, message, error, stackTrace));
  }

  /// Logs a warning message (Yellow).
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (level.index > LogLevel.warning.index) return;
    print(_formatMessage('WARNING', _yellow, message, error, stackTrace));
  }

  /// Logs an error message (Red).
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (level.index > LogLevel.error.index) return;
    print(_formatMessage('ERROR', _red, message, error, stackTrace));
  }
}
