import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:things/data/database/app_database.dart';
import 'package:things/i18n/translations.g.dart';

class ThoughtListWidget extends StatelessWidget {
  const ThoughtListWidget({
    required this.thoughts,
    super.key,
  });

  final List<Thought> thoughts;
  // final void Function(Thought thought) onDelete;

  @Preview()
  static Widget preview() => ThoughtListWidget(
    thoughts: List.generate(
      15,
      (i) => Thought(
        id: i,
        icon: String.fromCharCode(i + 0x1F600),
        title: 'Title $i',
        content: 'Content $i',
        createdAt: DateTime.now(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (thoughts.isEmpty) {
      return Center(child: Text(t.noThoughts));
    }

    return ListView(
      children: [
        for (final thought in thoughts)
          ListTile(
            leading: Text(thought.icon),
            title: Text(thought.title),
          ),
      ],
    );
  }
}
