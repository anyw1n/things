import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:things/ui/widgets/date_header_widget.dart';

void main() {
  testWidgets('DateHeaderWidget displays formatted date', (tester) async {
    final date = DateTime(2023); // Sunday, January 1
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DateHeaderWidget(date: date),
        ),
      ),
    );

    expect(find.text('Sunday, January 1'), findsOneWidget);
  });
}
