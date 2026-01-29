import 'package:flutter_test/flutter_test.dart';
import 'package:things/i18n/translations.g.dart';
import 'package:things/main.dart';

void main() {
  testWidgets('App launches and displays localized title', (tester) async {
    LocaleSettings.setLocale(AppLocale.en);

    await tester.pumpWidget(TranslationProvider(child: const MainApp()));
    await tester.pumpAndSettle();

    expect(find.text('Things'), findsOneWidget);
  });
}
