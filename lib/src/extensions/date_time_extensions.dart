/// Extensions for [DateTime].
extension DateTimeExtensions on DateTime {
  /// Returns a new [DateTime] with only the year, month, and day.
  DateTime get dateOnly => DateTime(year, month, day);

  /// Returns true if this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns true if this date is tomorrow.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Returns true if this date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns true if this date is exactly the same day as [other].
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Returns true if this date is in the current month.
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Returns true if this date is in the current year.
  bool get isThisYear {
    return year == DateTime.now().year;
  }

  /// Returns true if this date is on a weekend (Saturday or Sunday).
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Returns true if this date is on a weekday (Monday to Friday).
  bool get isWeekday => !isWeekend;

  /// Returns a new [DateTime] added by [days].
  DateTime addDays(int days) => add(Duration(days: days));

  /// Returns a new [DateTime] subtracted by [days].
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Returns a new [DateTime] added by [months].
  /// This handles varying month lengths (e.g. adding 1 month to Jan 31 gives Feb 28/29).
  DateTime addMonths(int months) {
    int newYear = year;
    int newMonth = month + months;

    while (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    while (newMonth < 1) {
      newYear--;
      newMonth += 12;
    }

    int newDay = day;
    final daysInNewMonth = _daysInMonth(newYear, newMonth);
    if (newDay > daysInNewMonth) {
      newDay = daysInNewMonth;
    }

    return DateTime(
      newYear,
      newMonth,
      newDay,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// Returns the first day of the current month.
  DateTime get firstDayOfMonth => DateTime(year, month, 1);

  /// Returns the last day of the current month.
  DateTime get lastDayOfMonth {
    if (month < 12) {
      return DateTime(
        year,
        month + 1,
        0,
      ); // 0th day of next month is last day of current
    } else {
      return DateTime(year + 1, 1, 0);
    }
  }

  /// Returns the first day of the current week (assuming Monday is the first day).
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1)).dateOnly;
  }

  /// Returns the last day of the current week (assuming Sunday is the last day).
  DateTime get endOfWeek {
    return add(Duration(days: DateTime.daysPerWeek - weekday)).dateOnly;
  }

  /// Calculates age in years based on this date as a birthdate.
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Returns a human-readable "time ago" string (e.g., "2 hours ago").
  String timeAgo({DateTime? clock}) {
    final now = clock ?? DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      return "In the future"; // Or handle similarly as timeFromNow
    }

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return "$years year${years > 1 ? 's' : ''} ago";
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return "$months month${months > 1 ? 's' : ''} ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "Just now";
    }
  }

  /// Returns a basic format: DD/MM/YYYY.
  String toDDMMYYYY({String separator = '/'}) {
    String d = day.toString().padLeft(2, '0');
    String m = month.toString().padLeft(2, '0');
    return "$d$separator$m$separator$year";
  }

  /// Returns a basic format: YYYY-MM-DD.
  String toYYYYMMDD({String separator = '-'}) {
    String d = day.toString().padLeft(2, '0');
    String m = month.toString().padLeft(2, '0');
    return "$year$separator$m$separator$d";
  }

  /// Returns a basic 12-hour time format: HH:MM AM/PM.
  String to12HourTime() {
    int h = hour > 12 ? hour - 12 : hour;
    if (h == 0) h = 12;
    String m = minute.toString().padLeft(2, '0');
    String period = hour >= 12 ? 'PM' : 'AM';
    return "$h:$m $period";
  }

  /// Helper to get days in a given month and year.
  static int _daysInMonth(int year, int month) {
    if (month == 2) {
      return _isLeapYear(year) ? 29 : 28;
    }
    const days = [31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
  }

  /// Helper to check if a year is a leap year.
  static bool _isLeapYear(int year) {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }
}

/// Extensions for nullable DateTime.
extension NullableDateTimeExtensions on DateTime? {
  /// Returns `true` if the date is null or in the past.
  bool get isNullOrPast {
    if (this == null) return true;
    return this!.isBefore(DateTime.now());
  }

  /// Returns `true` if the date is not null and in the future.
  bool get isNotNullAndFuture {
    if (this == null) return false;
    return this!.isAfter(DateTime.now());
  }
}
