# Core Extensions Documentation

This document provides a detailed overview of the extensions and utilities available in the `core_extensions` package.

## 1. String Extensions (`StringExtensions`)

Provides various methods for string manipulation, validation, and formatting.

*   `maskEmail()`: Masks an email address (e.g., `joh***@example.com`).
*   `camelCase`: Converts a string to camelCase.
*   `snakeCase`: Converts a string to snake_case.
*   `toSlug`: Converts a string to a URL-friendly slug.
*   `initials`: Extracts initials from a name (e.g., "John Doe" -> "JD").
*   `truncate(int length)`: Truncates a string and appends an ellipsis.
*   `isValidEmail`: Returns `true` if the string is a valid email.
*   `isValidUrl`: Returns `true` if the string is a valid URL.
*   `isValidIPv4`: Returns `true` if the string is a valid IPv4 address.
*   `capitalize()`: Capitalizes the first letter of the string.

## 2. DateTime Extensions (`DateTimeExtensions`)

Simplifies date handling, relative formatting, and comparisons.

*   `isToday`: Returns `true` if the date is today.
*   `isYesterday`: Returns `true` if the date is yesterday.
*   `isWeekend`: Returns `true` if the date falls on a Saturday or Sunday.
*   `timeAgo()`: Returns a human-readable relative time string (e.g., "2 hours ago", "Just now").
*   `addDays(int days)`: Adds days to a DateTime.
*   `subtractDays(int days)`: Subtracts days from a DateTime.
*   `isSameDay(DateTime other)`: Checks if two DateTime objects fall on the same calendar day.

## 3. List & Iterable Extensions (`IterableExtensions`, `ListExtensions`)

Enhances collections with data processing operations.

*   `chunked(int size)`: Splits a list into smaller lists of the specified size.
*   `getOrNull(int index)`: Safely retrieves an item at the given index, returning `null` if out of bounds.
*   `distinctBy(dynamic Function(E) selector)`: Returns unique elements based on a selector function.
*   `groupBy(K Function(E) keySelector)`: Groups elements into a `Map` based on the given key selector.
*   `sum()`: Calculates the sum of numerical items in an iterable.
*   `min()` / `max()`: Finds the minimum or maximum element in an iterable.

## 4. Map & Set Extensions (`MapExtensions`, `SetExtensions`)

Utilities for dictionaries and sets.

*   `union(Set other)`: Returns a new set containing elements from both sets.
*   `difference(Set other)`: Returns a new set containing elements not in the other set.
*   `toggle(E element)`: Adds the element if it's not in the set, removes it if it is.
*   `getDeep(String keyPath)`: Safely retrieves nested map values using a dot-notation key path.
*   `filterKeys()` / `filterValues()`: Filters the map based on keys or values.

## 5. Num & Duration Extensions (`NumExtensions`, `DurationExtensions`)

Helpers for numbers and time durations.

*   `toCompact()`: Returns a compact string representation (e.g., `1.5K`, `2M`).
*   `toCurrency(String symbol)`: Formats the number as currency.
*   `isBetween(num min, num max)`: Checks if the number is within the specified range (inclusive).
*   `clampMin(num min)` / `clampMax(num max)`: Restricts the number to a minimum or maximum bound.
*   `toReadableString()`: Converts a `Duration` into a readable format (e.g., "2h 30m").

## 6. Object Extensions (`ObjectExtensions`)

Kotlin-inspired scoping functions.

*   `let<R>(R Function(T) block)`: Executes the block with the object and returns the result.
*   `also(void Function(T) block)`: Executes the block with the object and returns the object itself.
*   `takeIf(bool Function(T) condition)`: Returns the object if the condition is met, otherwise `null`.

## 7. Utilities

*   **`Validators`**: Static methods for common regex validations (`Validators.isValidPan`, `Validators.isValidAadhaar`, etc.).
*   **`Debouncer`**: A class to debounce rapid sequential actions. Example: `final db = Debouncer(delay: 500.milliseconds); db.run(() => print('Hello'));`
*   **`Logger`**: A stylized console logger for debugging (`Logger.i()`, `Logger.e()`, `Logger.w()`, `Logger.d()`).

---
*For a quick start guide, please refer to the `README.md`.*
