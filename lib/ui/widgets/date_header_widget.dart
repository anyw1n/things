import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:intl/intl.dart';

class DateHeaderWidget extends StatelessWidget {
  const DateHeaderWidget({required this.date, super.key});

  final DateTime date;

  @Preview()
  static Widget preview() => DateHeaderWidget(date: DateTime.now());

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, MMMM d').format(date);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        formattedDate,
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
