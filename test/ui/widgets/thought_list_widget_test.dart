import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:things/core/database/app_database.dart';
import 'package:things/features/daily_thoughts/ui/widgets/thought_list_widget.dart';

void main() {
  testWidgets('ThoughtListWidget renders list of thoughts', (tester) async {
    final thoughts = [
      Thought(
        id: 1,
        icon: '😊',
        title: 'Happy thought',
        content: '',
        createdAt: .now(),
      ),
      Thought(
        id: 2,
        icon: '🤔',
        title: 'Pondering',
        content: '',
        createdAt: .now(),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ThoughtListWidget(thoughts: thoughts),
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
      const MaterialApp(
        home: Scaffold(
          body: ThoughtListWidget(thoughts: []),
        ),
      ),
    );

    expect(find.text('No thoughts for this day.'), findsOneWidget);
  });
}
