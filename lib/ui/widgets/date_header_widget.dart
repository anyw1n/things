import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:things/i18n/translations.g.dart';
import 'package:things/utils.dart';

class DateHeaderWidget extends StatelessWidget {
  const DateHeaderWidget({required this.date, super.key});

  final DateTime date;

  @Preview()
  static Widget preview() {
    initializeDateFormatting();
    return DateHeaderWidget(
      date: .now().subtract(const .new(days: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysDiff = DateTime.now().onlyDate.difference(date.onlyDate).inDays;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const .all(16),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: t.dailyScreen.dateHeaderTitle(
                context: switch (daysDiff) {
                  0 => .today,
                  1 => .yesterday,
                  _ => .other,
                },
                date: date,
              ),
              style: textTheme.displayMedium,
            ),
            const TextSpan(text: '\n'),
            TextSpan(
              text: t.dailyScreen.dateHeaderSubtitle(date: date),
              style: textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
