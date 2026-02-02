import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:things/i18n/translations.g.dart';
import 'package:things/ui/widgets/thought_input_widget.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocale(AppLocale.en);
  });

  testWidgets(
    'ThoughtInputWidget calls onSubmit when text is submitted',
    (tester) async {
      String? submittedText;
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: ThoughtInputWidget(
                onSubmit: (text) => submittedText = text,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'New thought');
      await tester.tap(find.byIcon(Icons.send));

      expect(submittedText, 'New thought');
    },
  );

  testWidgets(
    'ThoughtInputWidget does not call onSubmit when text is empty',
    (tester) async {
      var called = false;
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: ThoughtInputWidget(onSubmit: (_) => called = true),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.send));

      expect(called, false);
    },
  );
}
