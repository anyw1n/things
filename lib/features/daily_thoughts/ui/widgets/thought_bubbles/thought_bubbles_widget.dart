import 'dart:async';
import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors;
import 'package:things/core/database/app_database.dart';
import 'package:things/core/i18n/translations.g.dart';

part 'thought_bubbles_game.dart';
part 'screen_boundaries.dart';
part 'thought_body.dart';

class ThoughtBubblesWidget extends StatefulWidget {
  const ThoughtBubblesWidget({
    required this.thoughts,
    required this.isActive,
    super.key,
  });

  final List<Thought> thoughts;
  final bool isActive;

  @override
  State<ThoughtBubblesWidget> createState() => _ThoughtBubblesWidgetState();
}

class _ThoughtBubblesWidgetState extends State<ThoughtBubblesWidget> {
  final _game = _ThoughtBubblesGame();

  @override
  void initState() {
    super.initState();
    _game.updateThoughts(widget.thoughts);
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
