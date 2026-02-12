import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:things/ui/widgets/date_header_widget.dart';

void main() {
  setUp(initializeDateFormatting);

  testWidgets('DateHeaderWidget displays formatted date', (tester) async {
    final date = DateTime(2023); // Sunday, January 1
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DateHeaderWidget(date: date),
        ),
      ),
    );

    expect(find.text('Sunday\nJan 1', findRichText: true), findsOneWidget);
  });
}
