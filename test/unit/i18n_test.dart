import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:things/core/i18n/translations.g.dart';

void main() {
  group('i18n', () {
    test('English translations load correctly', () {
      LocaleSettings.setLocale(AppLocale.en);
      expect(t.title, 'Things');
    });

    test('All locales should be supported by Flutter', () {
      for (final locale in AppLocale.values) {
        // This will fail if the locale is not supported by Flutter
        expect(kMaterialSupportedLanguages, contains(locale.languageCode));
      }
    });
  });
}
