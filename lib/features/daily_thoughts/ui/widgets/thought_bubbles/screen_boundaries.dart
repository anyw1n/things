part of 'thought_bubbles_widget.dart';

/// Invisible looped chain that keeps bubbles inside visible world bounds.
class _ScreenBoundaries extends BodyComponent {
  static const _friction = 0.3;

  @override
  bool get renderBody => false;

  @override
  Body createBody() {
    return world.createBody(.new(position: .zero()));
  }

  /// Rebuilds a single boundary fixture to match current camera viewport.
  void _updateBoundaries() {
    final shape = ChainShape()
      ..createLoop(camera.visibleWorldRect.toVertices());
    final fixture = body.fixtures.singleOrNull;
    if (fixture != null) {
      body.destroyFixture(fixture);
    }
    body.createFixtureFromShape(shape, friction: _friction);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded && body.isActive) {
      _updateBoundaries();
    }
  }
}
