import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:thoughts/core/database/app_database.dart';
import 'package:thoughts/core/i18n/translations.g.dart';
import 'package:thoughts/core/router/app_router.dart';

class ThoughtListWidget extends StatelessWidget {
  const ThoughtListWidget({
    required this.thoughts,
    super.key,
  });

  final List<Thought> thoughts;

  @Preview()
  static Widget preview() => ThoughtListWidget(
    thoughts: .generate(
      15,
      (i) => Thought(
        id: i,
        icon: .fromCharCode(i + 0x1F600),
        title: 'Title $i',
        content: 'Content $i',
        createdAt: .now(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (thoughts.isEmpty) {
      return Center(
        child: Text(t.dailyScreen.noThoughts),
      );
    }

    return ListView(
      children: [
        for (final thought in thoughts)
          ListTile(
            leading: Text(thought.icon),
            title: Text(thought.title),
            onTap: () => ThoughtDetailsRoute(id: thought.id).go(context),
          ),
      ],
    );
  }
}
