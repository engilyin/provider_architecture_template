import 'package:flutter_test/flutter_test.dart';
import 'package:provider_start/core/mixins/validators.dart';

void main() {

  setUp(() {
  });

  group('email validator', () {
    test('should return null when email is valid', () {
      final result = Validators.validateEmail('example@gmail.com');
      expect(result, null);
    });

    test('should return null when email is valid with whitespace', () {
      final result = Validators.validateEmail('  example@gmail.com  ');
      expect(result, null);
    });

    test('should return error message when email is missing @', () {
      final result = Validators.validateEmail('examplegmail.com');
      expect(result.runtimeType, String);
    });

    test('should return error message when email is missing @ prefix', () {
      final result = Validators.validateEmail('@gmail.com');
      expect(result.runtimeType, String);
    });
  });

  group('zip code validator', () {
    test('should return null when zip code is valid', () {
      final cupertinoZipCode = '95014';
      final result = Validators.validateZip(cupertinoZipCode);
      expect(result, null);
    });

    test('should return null when full zip code is valid', () {
      final cupertinoZipCode = '95014-1234';
      final result = Validators.validateZip(cupertinoZipCode);
      expect(result, null);
    });

    test('should return null when zip code is valid with whitespace', () {
      final cupertinoZipCode = '  95014  ';
      final result = Validators.validateZip(cupertinoZipCode);
      expect(result, null);
    });

    test('should return error message when full zip code is invalid length',
        () {
      final cupertinoZipCode = '9501';
      final result = Validators.validateZip(cupertinoZipCode);
      expect(result.runtimeType, String);
    });
  });

  group('phone number validator', () {
    test('should return null when phone number is valid', () {
      final result = Validators.validatePhoneNumber('1112223333');
      expect(result, null);
    });

    test('should return null when phone number is valid', () {
      final result = Validators.validatePhoneNumber('(111) 222-3333');
      expect(result, null);
    });

    test('should return null when phone number is valid with whitespace', () {
      final result = Validators.validatePhoneNumber('  1112223333  ');
      expect(result, null);
    });

    test('should return error message when phone number is invalid length', () {
      final result = Validators.validatePhoneNumber('(1111) 222-3333');
      expect(result.runtimeType, String);
    });

    test('should return error message when phone number is invalid length', () {
      final result = Validators.validatePhoneNumber('111222333333333');
      expect(result.runtimeType, String);
    });
  });
}
