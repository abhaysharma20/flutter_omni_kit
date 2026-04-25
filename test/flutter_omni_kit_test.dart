import 'package:flutter_omni_kit/flutter_omni_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('String Extensions', () {
    test('capitalize', () {
      expect('hello'.capitalize, 'Hello');
      expect(''.capitalize, '');
    });

    test('camelCase', () {
      expect('hello_world'.camelCase, 'helloWorld');
      expect('HELLO WORLD'.camelCase, 'helloWorld');
    });

    test('mask', () {
      expect('1234567890'.mask(start: 2, end: 2), '12******90');
    });

    test('isAlpha', () {
      expect('Hello'.isAlpha, true);
      expect('Hello123'.isAlpha, false);
    });
  });

  group('DateTime Extensions', () {
    test('isToday', () {
      expect(DateTime.now().isToday, true);
      expect(DateTime.now().subtract(const Duration(days: 1)).isToday, false);
    });

    test('addMonths', () {
      final date = DateTime(2023, 1, 31);
      final newDate = date.addMonths(1);
      // Feb 28th
      expect(newDate.year, 2023);
      expect(newDate.month, 2);
      expect(newDate.day, 28);
    });
  });

  group('List Extensions', () {
    test('getOrNull', () {
      final list = [1, 2, 3];
      expect(list.getOrNull(1), 2);
      expect(list.getOrNull(5), null);
    });

    test('chunked', () {
      final list = [1, 2, 3, 4, 5];
      final chunks = list.chunked(2).toList();
      expect(chunks.length, 3);
      expect(chunks[0], [1, 2]);
      expect(chunks[2], [5]);
    });
  });

  group('Num Extensions', () {
    test('clamp', () {
      expect(15.clamp(1, 10), 10);
      expect(5.clamp(1, 10), 5);
      expect(0.clamp(1, 10), 1);
    });

    test('toCompact', () {
      expect(1500.toCompact(), '1.5K');
      expect(1500000.toCompact(), '1.5M');
    });
  });

  group('Validators', () {
    test('isValidEmail', () {
      expect(Validators.isValidEmail('test@example.com'), true);
      expect(Validators.isValidEmail('invalid-email'), false);
    });

    test('isValidPAN', () {
      expect(Validators.isValidPAN('ABCDE1234F'), true);
      expect(Validators.isValidPAN('12345ABCDE'), false);
    });
  });
}
