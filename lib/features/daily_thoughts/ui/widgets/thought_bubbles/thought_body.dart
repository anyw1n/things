part of 'thought_bubbles_widget.dart';

class _ThoughtBody extends BodyComponent with DragCallbacks, TapCallbacks {
  _ThoughtBody({
    required this.thought,
    required double initialRadius,
    required this.initialPosition,
    required this.groundBody,
    required this.onTap,
  }) : _radius = initialRadius,
       super(
         paint: .new()
           ..color = Colors.white38
           ..style = .stroke
           ..strokeWidth = _strokeWidth,
       );

  final _textPaint = TextPaint(style: const .new(fontSize: _fontSize));

  final Vector2 initialPosition;
  final Body groundBody;
  final void Function(int id) onTap;

  Thought thought;

  double _radius;
  double get radius => _radius;
  set radius(double value) {
    _radius = value;
    if (isLoaded && body.isActive) {
      _updateFixture(body);
    }
  }

  MouseJoint? _mouseJoint;

  static const _restitution = 0.6;
  static const _friction = 0.2;
  static const _linearDamping = 0.5;
  static const _angularDamping = 0.5;

  static const _strokeWidth = 0.2;
  static const _fontSize = 20.0;
  static const _baseFontScale = 0.1;

  static const _dragMaxForceMultiplier =
      _ThoughtBubblesGame._defaultGravity * 1000;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      type: .dynamic,
      linearDamping: _linearDamping,
      angularDamping: _angularDamping,
    );
    final body = world.createBody(bodyDef);
    _updateFixture(body);
    return body;
  }

  void _updateFixture(Body body) {
    final fixture = body.fixtures.singleOrNull;
    if (fixture != null) {
      body.destroyFixture(fixture);
    }
    body.createFixtureFromShape(
      CircleShape(radius: _radius),
      restitution: _restitution,
      friction: _friction,
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(.zero, _radius - (_strokeWidth / 2), paint);

    final textScale =
        math.min(_fontSize * _baseFontScale, _radius * 2) / _fontSize;

    canvas
      ..save()
      ..scale(textScale);

    _textPaint.render(canvas, thought.icon, .zero(), anchor: .center);

    canvas.restore();
  }

  void _keepInsideBounds() {
    final bounds = camera.visibleWorldRect;
    final Vector2(x: curX, y: curY) = body.position;

    final clampedX = curX.clamp(bounds.left + _radius, bounds.right - _radius);
    final clampedY = curY.clamp(bounds.top + _radius, bounds.bottom - _radius);

    if (clampedX == curX && clampedY == curY) return;

    body
      ..setTransform(.new(clampedX, clampedY), body.angle)
      ..linearVelocity = .zero()
      ..angularVelocity = 0;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded && body.isActive) {
      _keepInsideBounds();
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_mouseJoint != null) return;

    final mouseJointDef = MouseJointDef()
      ..bodyA = groundBody
      ..bodyB = body
      ..maxForce = body.mass * _dragMaxForceMultiplier
      ..target.setFrom(body.worldPoint(event.localPosition));

    _mouseJoint = .new(mouseJointDef);
    world.createJoint(_mouseJoint!);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _mouseJoint?.setTarget(body.worldPoint(event.localEndPosition));
  }

  void _removeJoint() {
    if (_mouseJoint == null) return;
    world.destroyJoint(_mouseJoint!);
    _mouseJoint = null;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _removeJoint();
  }

  @override
  void onTapUp(TapUpEvent event) => onTap(thought.id);

  @override
  void onRemove() {
    _removeJoint();
    super.onRemove();
  }
}
