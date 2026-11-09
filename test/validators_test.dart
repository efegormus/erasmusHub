import 'package:erasmus_hub/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Required rejects missing and whitespace-only input', () {
    for (final value in [null, '', '   ']) {
      expect(Validators.required(value), isNotNull);
    }
    expect(Validators.required(' Efe '), isNull);
  });
  test('Minimum length handles boundaries without trimming passwords', () {
    final validate = Validators.minLength(8);
    expect(validate(null), isNotNull);
    expect(validate('1234567'), isNotNull);
    expect(validate('12345678'), isNull);
    expect(validate(' 123456 '), isNull);
    expect(() => Validators.minLength(-1), throwsArgumentError);
  });
  test('University email accepts academic domains and subdomains', () {
    for (final email in [
      'student@mit.edu',
      ' EFE@SABANCIUNIV.EDU ',
      'student@ogr.university.edu.tr',
      'student@ox.ac.uk',
    ]) {
      expect(Validators.universityEmail(email), isNull, reason: email);
    }
  });
  test(
    'University email rejects malformed addresses and suffix lookalikes',
    () {
      for (final email in [
        null,
        '',
        ' ',
        'student@gmail.com',
        'student@edu.tr',
        'student@university.edu.evil.com',
        'student@@mit.edu',
        'student name@mit.edu',
        '.student@mit.edu',
        'a..b@mit.edu',
        'student@-mit.edu',
        'student@mit..edu',
        'student@mit.edu.',
      ]) {
        expect(Validators.universityEmail(email), isNotNull, reason: email);
      }
    },
  );
}
