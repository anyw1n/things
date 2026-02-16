import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:things/ui/widgets/thought_input_widget.dart';

void main() {
  testWidgets(
    'ThoughtInputWidget calls onSubmit when text is submitted',
    (tester) async {
      String? submittedText;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThoughtInputWidget(
              enabled: true,
              isLoading: false,
              onSubmit: (text) => submittedText = text,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'New thought');
      await tester.tap(find.byIcon(Icons.arrow_upward_rounded));

      expect(submittedText, 'New thought');
    },
  );

  testWidgets(
    'ThoughtInputWidget does not call onSubmit when text is empty',
    (tester) async {
      var called = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThoughtInputWidget(
              enabled: true,
              isLoading: false,
              onSubmit: (_) => called = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_upward_rounded));

      expect(called, false);
    },
  );
}
