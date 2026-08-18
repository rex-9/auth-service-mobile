// test/locales_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:rexone_mobile/locales/app_translations.dart';

void main() {
  test('All languages have 100% complete translation keys without omission', () {
    final trans = AppTranslations().keys;
    final en = trans['en_US']!;
    final es = trans['es_ES']!;
    final my = trans['my_MM']!;

    expect(en.isNotEmpty, true);
    expect(es.isNotEmpty, true);
    expect(my.isNotEmpty, true);

    final missingInEs = en.keys.where((k) => !es.containsKey(k)).toList();
    final missingInMy = en.keys.where((k) => !my.containsKey(k)).toList();

    expect(missingInEs, isEmpty, reason: 'Missing keys in es_ES: $missingInEs');
    expect(missingInMy, isEmpty, reason: 'Missing keys in my_MM: $missingInMy');

    final missingInEnFromEs = es.keys.where((k) => !en.containsKey(k)).toList();
    final missingInEnFromMy = my.keys.where((k) => !en.containsKey(k)).toList();

    expect(missingInEnFromEs, isEmpty, reason: 'Missing keys in en_US: $missingInEnFromEs');
    expect(missingInEnFromMy, isEmpty, reason: 'Missing keys in en_US: $missingInEnFromMy');
  });
}
