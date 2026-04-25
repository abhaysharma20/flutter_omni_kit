import 'package:flutter_omni_kit/flutter_omni_kit.dart';

void main() async {
  // =========================================================================
  // 1. String Extensions
  // =========================================================================
  print('--- String Extensions ---');
  String text = 'hello world';
  print(text.capitalize); // Hello world
  print(text.titleCase); // Hello World
  print(text.camelCase); // helloWorld

  String email = 'john.doe@example.com';
  print(email.maskEmail()); // joh***@example.com
  print('1234567890'.mask(start: 2, end: 8)); // 12******90

  // =========================================================================
  // 2. DateTime Extensions
  // =========================================================================
  print('\n--- DateTime Extensions ---');
  DateTime now = DateTime.now();
  print(now.isToday); // true
  print(
    now.addDays(5).timeAgo(),
  ); // In the future (or handles natively based on your impl)
  print(now.subtractDays(2).timeAgo()); // 2 days ago
  print(now.to12HourTime()); // e.g. 2:30 PM

  // =========================================================================
  // 3. List & Iterable Extensions
  // =========================================================================
  print('\n--- List/Iterable Extensions ---');
  List<int> numbers = [1, 2, 3, 4, 5, 5, 6];
  numbers.removeDuplicatesBy((e) => e);
  print(numbers); // [1, 2, 3, 4, 5, 6]

  var chunks = numbers.chunked(2).toList();
  print(chunks); // [[1, 2], [3, 4], [5, 6]]

  var sum = numbers.sum();
  print(sum); // 21

  // =========================================================================
  // 4. Num Extensions
  // =========================================================================
  print('\n--- Num Extensions ---');
  int amount = 1500000;
  print(amount.toCompact()); // 1.5M

  double price = 1234.56;
  print(price.toCurrency(symbol: '₹')); // ₹1,234.56

  print(5.isBetween(1, 10)); // true

  // =========================================================================
  // 5. Utilities (Logger, Validators, Debouncer)
  // =========================================================================
  print('\n--- Utilities ---');
  Logger.level = LogLevel.debug;
  Logger.i('This is an info message');
  Logger.w('This is a warning message');

  print('Is valid email? ${Validators.isValidEmail('test@test.com')}'); // true
  print('Is valid PAN? ${Validators.isValidPAN('ABCDE1234F')}'); // true
  print(
    'Is strong password? ${Validators.isStrongPassword('Weak1!')}',
  ); // false (length < 8)

  final debouncer = Debouncer(delay: 500.milliseconds);
  debouncer.run(() => print('This will be debounced!'));
}
