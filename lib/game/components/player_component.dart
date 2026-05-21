import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:night_siege/game/geometry/isometric_projection.dart';

/// Visible player placeholder with keyboard-driven world-space movement.
class PlayerComponent extends PositionComponent {
  /// Creates a player constrained to the given world arena size.
  ///
  /// The [position] argument is kept as a Phase 1/2 compatibility alias for
  /// [worldPosition]. New gameplay code should read and write [worldPosition].
  PlayerComponent({
    required Vector2 arenaSize,
    Vector2? worldPosition,
    Vector2? position,
    IsometricProjection? projection,
  }) : _arenaSize = arenaSize.clone(),
       _worldPosition = (worldPosition ?? position ?? Vector2.zero()).clone(),
       _projection = projection ?? _defaultProjection,
       _footprintPaint = Paint()..color = const Color(0x66343238),
       _bodyPaint = Paint()..color = const Color(0xFFE8E2C8),
       _edgePaint = Paint()
         ..color = const Color(0xFF2A2727)
         ..style = PaintingStyle.stroke
         ..strokeWidth = 1.5,
       super(size: Vector2(32, 52), anchor: const Anchor(0.5, 0.78)) {
    _clampToArena();
    updateProjectedPosition();
  }

  /// Movement speed in world units per second.
  static const double speed = 3.5;

  /// Multiplier used to preserve fractional depth keys in Flame priorities.
  static const int depthPriorityScale = 1000;

  static final Vector2 _worldFootprintSize = Vector2.all(0.56);
  static final IsometricProjection _defaultProjection = IsometricProjection(
    tileSize: Vector2(64, 32),
  );

  final Vector2 _arenaSize;
  final Vector2 _worldPosition;
  IsometricProjection _projection;
  Set<LogicalKeyboardKey> _keysPressed = {};

  final Paint _footprintPaint;
  final Paint _bodyPaint;
  final Paint _edgePaint;

  /// Approximate world-space footprint used for arena bounds.
  Vector2 get worldFootprintSize => _worldFootprintSize.clone();

  /// Canonical gameplay position in bounded world coordinates.
  Vector2 get worldPosition => _worldPosition.clone();

  set worldPosition(Vector2 worldPosition) {
    _worldPosition.setFrom(worldPosition);
    _clampToArena();
    updateProjectedPosition();
  }

  /// Current projection used to derive Flame screen position and priority.
  IsometricProjection get projection => _projection;

  /// Current keyboard state used to calculate movement on the next update.
  Set<LogicalKeyboardKey> get keysPressed => _keysPressed;

  /// Replaces the keyboard state copied from Flame's keyboard event callback.
  set keysPressed(Set<LogicalKeyboardKey> keysPressed) {
    _keysPressed = Set<LogicalKeyboardKey>.unmodifiable(keysPressed);
  }

  @override
  set position(Vector2 position) {
    worldPosition = position;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final direction = Vector2.zero();

    if (_isPressed(LogicalKeyboardKey.keyW, LogicalKeyboardKey.arrowUp)) {
      direction.y -= 1;
    }
    if (_isPressed(LogicalKeyboardKey.keyS, LogicalKeyboardKey.arrowDown)) {
      direction.y += 1;
    }
    if (_isPressed(LogicalKeyboardKey.keyA, LogicalKeyboardKey.arrowLeft)) {
      direction.x -= 1;
    }
    if (_isPressed(LogicalKeyboardKey.keyD, LogicalKeyboardKey.arrowRight)) {
      direction.x += 1;
    }

    if (direction.length2 > 0) {
      _worldPosition.add(direction.normalized() * speed * dt);
    }

    _clampToArena();
    updateProjectedPosition();
  }

  /// Updates the world arena used for bounds clamping.
  void updateArenaSize(Vector2 arenaSize) {
    _arenaSize.setFrom(arenaSize);
    _clampToArena();
    updateProjectedPosition();
  }

  /// Reprojects the component after [worldPosition] or [projection] changes.
  void updateProjectedPosition({IsometricProjection? projection}) {
    if (projection != null) {
      _projection = projection;
    }

    super.position = _projection.project(_worldPosition);
    priority = (_projection.depthKey(_worldPosition) * depthPriorityScale)
        .round();
  }

  @override
  void render(Canvas canvas) {
    final groundCenter = Offset(size.x / 2, size.y * 0.78);

    final footprintRect = Rect.fromCenter(
      center: groundCenter,
      width: 22,
      height: 10,
    );

    final bodyPath = Path()
      ..moveTo(groundCenter.dx, groundCenter.dy - 34)
      ..lineTo(groundCenter.dx + 8, groundCenter.dy - 8)
      ..lineTo(groundCenter.dx, groundCenter.dy + 1)
      ..lineTo(groundCenter.dx - 8, groundCenter.dy - 8)
      ..close();

    final headCenter = Offset(groundCenter.dx, groundCenter.dy - 37);

    canvas
      ..drawOval(footprintRect, _footprintPaint)
      ..drawPath(bodyPath, _bodyPaint)
      ..drawPath(bodyPath, _edgePaint)
      ..drawCircle(headCenter, 4.5, _bodyPaint)
      ..drawCircle(headCenter, 4.5, _edgePaint);
  }

  bool _isPressed(LogicalKeyboardKey primary, LogicalKeyboardKey alternate) {
    return _keysPressed.contains(primary) || _keysPressed.contains(alternate);
  }

  void _clampToArena() {
    final halfSize = _worldFootprintSize / 2;

    final maxBounds = Vector2(
      math.max(halfSize.x, _arenaSize.x - halfSize.x),
      math.max(halfSize.y, _arenaSize.y - halfSize.y),
    );

    _worldPosition.clamp(halfSize, maxBounds);
  }
}
