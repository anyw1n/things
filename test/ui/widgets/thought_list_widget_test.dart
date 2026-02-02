import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:things/data/database/app_database.dart';
import 'package:things/i18n/translations.g.dart';
import 'package:things/ui/widgets/thought_list_widget.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocale(AppLocale.en);
  });

  testWidgets('ThoughtListWidget renders list of thoughts', (tester) async {
    final thoughts = [
      Thought(
        id: 1,
        icon: '😊',
        title: 'Happy thought',
        content: '',
        createdAt: DateTime.now(),
      ),
      Thought(
        id: 2,
        icon: '🤔',
        title: 'Pondering',
        content: '',
        createdAt: DateTime.now(),
      ),
    ];

    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: Scaffold(
            body: ThoughtListWidget(thoughts: thoughts),
          ),
        ),
      ),
    );

    expect(find.text('Happy thought'), findsOneWidget);
    expect(find.text('Pondering'), findsOneWidget);
    expect(find.text('😊'), findsOneWidget);
  });

  testWidgets('ThoughtListWidget renders empty message when empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: const MaterialApp(
          home: Scaffold(
            body: ThoughtListWidget(thoughts: []),
          ),
        ),
      ),
    );

    expect(find.text('No thoughts for this day.'), findsOneWidget);
  });
}
