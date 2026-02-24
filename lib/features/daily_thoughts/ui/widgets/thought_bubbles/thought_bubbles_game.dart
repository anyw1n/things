part of 'thought_bubbles_widget.dart';

class _ThoughtBubblesGame extends Forge2DGame {
  _ThoughtBubblesGame({required this.onThoughtTap})
    : super(gravity: .new(0, _defaultGravity));

  final void Function(int id) onThoughtTap;

  /// Thoughts that will be added on game load.
  List<Thought> _pendingThoughts = [];

  /// Static body used as anchor for drags.
  late Body _groundBody;

  StreamSubscription<sensors.AccelerometerEvent>? _accelSub;
  StreamSubscription<sensors.UserAccelerometerEvent>? _userAccelSub;

  /// Max occupied area with circles * multiplier to always leave free space / pi.
  static const _areaMultiplier = 0.907 * 0.7 / math.pi;
  static const _maxCircleRadius = 4.5;

  /// Specifies the radius difference for re-rendering.
  static const _radiusUpdateThreshold = 0.01;

  static const _baseGravity = 9.8;
  static const _gravityScale = 5.0;
  static const _defaultGravity = _baseGravity * _gravityScale;

  static const _shakeThreshold = 400.0;
  static const _shakeImpulse = 600.0;

  static final _random = math.Random();

  /// Computes a shared bubble radius that keeps occupied area visually
  /// balanced.
  double _calculateCircleRadius(Rect rect, int circlesNumber) {
    if (circlesNumber <= 0) return _maxCircleRadius;
    return math.min(
      math.sqrt(rect.width * rect.height * _areaMultiplier / circlesNumber),
      _maxCircleRadius,
    );
  }

  /// Returns a random spawn point in the currently visible world rect.
  Vector2 get _randomPosition {
    final Rect(:left, :top, :width, :height) = camera.visibleWorldRect;
    return .new(
      left + _random.nextDouble() * width,
      top + _random.nextDouble() * height / 2,
    );
  }

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    _startSensorListeners();

    _groundBody = world.createBody(.new());

    await world.add(_ScreenBoundaries());

    if (_pendingThoughts.isNotEmpty) {
      _updateThoughts(_pendingThoughts);
      _pendingThoughts = [];
    }
  }

  /// Binds device sensors to gravity updates and shake gesture detection.
  void _startSensorListeners() {
    _accelSub = sensors.accelerometerEventStream().listen((event) {
      world.gravity = .new(-event.x * _gravityScale, event.y * _gravityScale);
    });

    _userAccelSub = sensors.userAccelerometerEventStream().listen((event) {
      final acceleration2 =
          event.x * event.x + event.y * event.y + event.z * event.z;
      if (acceleration2 > _shakeThreshold) {
        _onShake();
      }
    });
  }

  /// Applies random impulses to all bubbles to create a shake effect.
  void _onShake() {
    for (final bodyComponent in world.children.whereType<_ThoughtBody>()) {
      bodyComponent.body.applyLinearImpulse(
        .new(
            _random.nextDoubleBetween(-1, 1),
            _random.nextDoubleBetween(-1, 1),
          )
          ..normalize()
          ..scale(_shakeImpulse),
      );
    }
  }

  @override
  void onRemove() {
    _accelSub?.cancel();
    _userAccelSub?.cancel();
    super.onRemove();
  }

  /// Checks the radius difference for re-rendering.
  bool _radiiExceedThreshold(double a, double b) =>
      (a - b).abs() > _radiusUpdateThreshold;

  /// Resizes all circles after viewport changes to preserve density.
  void _resizeCirclesIfNeeded() {
    final bodies = world.children.whereType<_ThoughtBody>();
    if (bodies.isEmpty) return;

    final radius = _calculateCircleRadius(
      camera.visibleWorldRect,
      bodies.length,
    );
    if (!_radiiExceedThreshold(bodies.first.radius, radius)) return;

    for (final body in bodies) {
      body.radius = radius;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _resizeCirclesIfNeeded();
  }

  /// Applies thought updates immediately or stores them until game is loaded.
  void updateThoughts(List<Thought> newThoughts) {
    if (!isLoaded) {
      _pendingThoughts = newThoughts;
      return;
    }
    _updateThoughts(newThoughts);
  }

  /// Reconciles existing bodies with new data by id and updates only diffs.
  void _updateThoughts(List<Thought> newThoughts) {
    final existingBodies = world.children.whereType<_ThoughtBody>().toList();
    final newThoughtsMap = {for (final t in newThoughts) t.id: t};

    final radius = _calculateCircleRadius(
      camera.visibleWorldRect,
      newThoughts.length,
    );

    final shouldUpdateRadius =
        existingBodies.isNotEmpty &&
        _radiiExceedThreshold(existingBodies.first.radius, radius);

    for (final body in existingBodies) {
      final id = body.thought.id;
      final thought = newThoughtsMap[id];

      if (thought != null) {
        body.thought = thought;
        if (shouldUpdateRadius) {
          body.radius = radius;
        }
        newThoughtsMap.remove(id);
      } else {
        world.remove(body);
      }
    }

    final bodies = newThoughtsMap.values.map(
      (thought) => _ThoughtBody(
        thought: thought,
        initialRadius: radius,
        initialPosition: _randomPosition,
        groundBody: _groundBody,
        onTap: onThoughtTap,
      ),
    );
    world.addAll(bodies);
  }
}
