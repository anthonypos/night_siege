import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'components/player_component.dart';
import 'components/safehouse_component.dart';
import 'geometry/isometric_projection.dart';
import 'models/resources.dart';

/// Flame game root for the current playable checkpoint.
class NightSiegeGame extends FlameGame with KeyboardEvents {
  /// Safehouse health used for the Phase 2 baseline.
  static const int safehouseMaxHealth = 100;

  /// Starter phase label shown before a fuller phase model exists.
  static const String initialPhaseLabel = 'Prepare';

  static final Vector2 _worldArenaSize = Vector2.all(10);
  static final Vector2 _initialPlayerWorldPosition = Vector2(5, 6.5);
  static final Vector2 _safehouseWorldPosition = Vector2(5, 3.2);
  static final Vector2 _projectionTileSize = Vector2(64, 32);

  static final IsometricProjection _defaultProjection = IsometricProjection(
    tileSize: _projectionTileSize,
    origin: Vector2(320, 40),
  );

  static final Paint _backgroundPaint = Paint()
    ..color = const Color(0xFF101820);

  static final Paint _arenaFloorPaint = Paint()
    ..color = const Color(0xFF26352F);

  static final Paint _arenaEdgePaint = Paint()
    ..color = const Color(0xFF485E55)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  /// Player placeholder controlled by keyboard input.
  late final PlayerComponent player;

  /// Safehouse placeholder tracked as the run's base.
  final SafehouseComponent safehouse = SafehouseComponent(
    maxHealth: safehouseMaxHealth,
    worldPosition: _safehouseWorldPosition,
    projection: _defaultProjection,
  );

  /// Mutable resources for the current run.
  final Resources resources = Resources.starter();

  /// Current high-level phase label shown by UI surfaces.
  String phaseLabel = initialPhaseLabel;

  /// Revision notifier for HUDs that read game-owned state.
  final ValueNotifier<int> hudRevision = ValueNotifier<int>(0);

  /// Bounded world-space arena used for movement and future spatial systems.
  Vector2 get worldArenaSize => _worldArenaSize.clone();

  /// Initial player world-space anchor used by load and restart.
  Vector2 get initialPlayerWorldPosition => _initialPlayerWorldPosition.clone();

  /// Safehouse world-space anchor used by load and restart.
  Vector2 get safehouseWorldPosition => _safehouseWorldPosition.clone();

  /// Current projection used to derive screen positions from world positions.
  IsometricProjection isometricProjection = _defaultProjection;

  @override
  Color backgroundColor() => const Color(0xFF101820);

  @override
  Future<void> onLoad() async {
    isometricProjection = _projectionForViewport(size);

    player = PlayerComponent(
      arenaSize: _worldArenaSize,
      worldPosition: _initialPlayerWorldPosition,
      projection: isometricProjection,
    );

    safehouse
      ..worldPosition = _safehouseWorldPosition
      ..updateProjectedPosition(projection: isometricProjection);

    await add(safehouse);
    await add(player);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    isometricProjection = _projectionForViewport(size);

    if (isLoaded) {
      player
        ..updateArenaSize(_worldArenaSize)
        ..updateProjectedPosition(projection: isometricProjection);

      safehouse.updateProjectedPosition(projection: isometricProjection);
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    player.keysPressed = keysPressed;
    return KeyEventResult.handled;
  }

  /// Resets run-scoped state to the Phase 2 starter values.
  void restartRun() {
    player
      ..worldPosition = _initialPlayerWorldPosition
      ..keysPressed = {}
      ..updateProjectedPosition(projection: isometricProjection);

    safehouse
      ..worldPosition = _safehouseWorldPosition
      ..resetHealth()
      ..updateProjectedPosition(projection: isometricProjection);

    resources.resetStarter();
    phaseLabel = initialPhaseLabel;
    hudRevision.value++;
  }

  @override
  void onRemove() {
    hudRevision.dispose();
    super.onRemove();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _backgroundPaint);

    _renderArenaFloor(canvas);

    super.render(canvas);
  }

  IsometricProjection _projectionForViewport(Vector2 viewportSize) {
    const double minimumProjectionTopMargin = 40;

    final worldDiagonal = _worldArenaSize.x + _worldArenaSize.y;
    final projectedArenaHeight = worldDiagonal * _projectionTileSize.y / 2;
    final centeredTopMargin = (viewportSize.y - projectedArenaHeight) / 2;
    final originY = math.max(centeredTopMargin, minimumProjectionTopMargin);

    return IsometricProjection(
      tileSize: _projectionTileSize,
      origin: Vector2(viewportSize.x / 2, originY),
    );
  }

  void _renderArenaFloor(Canvas canvas) {
    final corners = <Vector2>[
      Vector2.zero(),
      Vector2(_worldArenaSize.x, 0),
      _worldArenaSize,
      Vector2(0, _worldArenaSize.y),
    ].map(isometricProjection.project).toList();

    final floorPath = Path()
      ..moveTo(corners[0].x, corners[0].y)
      ..lineTo(corners[1].x, corners[1].y)
      ..lineTo(corners[2].x, corners[2].y)
      ..lineTo(corners[3].x, corners[3].y)
      ..close();

    canvas
      ..drawPath(floorPath, _arenaFloorPaint)
      ..drawPath(floorPath, _arenaEdgePaint);
  }
}
