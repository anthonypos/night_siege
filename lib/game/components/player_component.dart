import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Visible Phase 1 player placeholder with keyboard-driven arena movement.
class PlayerComponent extends RectangleComponent {
  /// Creates a player constrained to the given visible arena size.
  PlayerComponent({required Vector2 arenaSize, Vector2? position})
    : _arenaSize = arenaSize.clone(),
      super(
        position: position?.clone(),
        size: Vector2.all(28),
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xFFE8E2C8),
      );

  /// Movement speed in logical pixels per second.
  static const double speed = 180;

  Vector2 _arenaSize;
  Set<LogicalKeyboardKey> _keysPressed = {};

  /// Current keyboard state used to calculate movement on the next update.
  Set<LogicalKeyboardKey> get keysPressed => _keysPressed;

  /// Replaces the keyboard state copied from Flame's keyboard event callback.
  set keysPressed(Set<LogicalKeyboardKey> keysPressed) {
    _keysPressed = Set<LogicalKeyboardKey>.unmodifiable(keysPressed);
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
      position += direction.normalized() * speed * dt;
    }

    _clampToArena();
  }

  /// Updates the arena used for bounds clamping after a viewport resize.
  void updateArenaSize(Vector2 arenaSize) {
    _arenaSize = arenaSize.clone();
    _clampToArena();
  }

  bool _isPressed(LogicalKeyboardKey primary, LogicalKeyboardKey alternate) {
    return _keysPressed.contains(primary) || _keysPressed.contains(alternate);
  }

  void _clampToArena() {
    final halfSize = size / 2;
    final maxBounds = Vector2(
      math.max(halfSize.x, _arenaSize.x - halfSize.x),
      math.max(halfSize.y, _arenaSize.y - halfSize.y),
    );

    position.clamp(halfSize, maxBounds);
  }
}
