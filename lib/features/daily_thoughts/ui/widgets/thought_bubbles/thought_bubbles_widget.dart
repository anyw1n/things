import 'dart:async';
import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors;
import 'package:thoughts/core/database/app_database.dart';
import 'package:thoughts/core/i18n/translations.g.dart';
import 'package:thoughts/core/router/app_router.dart';

part 'screen_boundaries.dart';
part 'thought_body.dart';
part 'thought_bubbles_game.dart';

/// Physics-based thought visualization rendered as draggable bubbles.
class ThoughtBubblesWidget extends StatefulWidget {
  const ThoughtBubblesWidget({
    required this.thoughts,
    required this.isActive,
    super.key,
  });

  /// Thoughts currently represented by bubbles.
  final List<Thought> thoughts;

  /// Whether simulation updates are active for the current page.
  final bool isActive;

  @override
  State<ThoughtBubblesWidget> createState() => _ThoughtBubblesWidgetState();
}

class _ThoughtBubblesWidgetState extends State<ThoughtBubblesWidget> {
  late final _ThoughtBubblesGame _game;

  void _onThoughtTap(int thoughtId) async {
    final wasPaused = _game.paused;
    if (!wasPaused) {
      _game.pauseEngine();
    }

    await ThoughtDetailsRoute(id: thoughtId).push<void>(context);

    if (mounted && !wasPaused && widget.isActive && _game.paused) {
      _game.resumeEngine();
    }
  }

  @override
  void initState() {
    super.initState();
    _game = _ThoughtBubblesGame(onThoughtTap: _onThoughtTap)
      ..updateThoughts(widget.thoughts);
    if (!widget.isActive && !_game.paused) {
      _game.pauseEngine();
    }
  }

  @override
  void didUpdateWidget(covariant ThoughtBubblesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _game.updateThoughts(widget.thoughts);
    if (widget.isActive && _game.paused) {
      _game.resumeEngine();
    } else if (!widget.isActive && !_game.paused) {
      _game.pauseEngine();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.thoughts.isEmpty
        ? Center(child: Text(t.dailyScreen.noThoughts))
        : GameWidget(game: _game);
  }
}
