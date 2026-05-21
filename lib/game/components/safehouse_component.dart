import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Placeholder safehouse base with resettable health for Phase 2 state wiring.
class SafehouseComponent extends PositionComponent {
  /// Creates the safehouse placeholder at the given position.
  SafehouseComponent({Vector2? position, this.maxHealth = 100})
    : currentHealth = maxHealth,
      _wallPaint = Paint()..color = const Color(0xFF7A6A55),
      _roofPaint = Paint()..color = const Color(0xFFB86B4B),
      _doorPaint = Paint()..color = const Color(0xFF3B2A21),
      super(
        position: position?.clone(),
        size: Vector2(80, 64),
        anchor: Anchor.center,
      );

  /// Maximum structural health for the safehouse.
  final int maxHealth;

  /// Current structural health for the safehouse.
  int currentHealth;

  final Paint _wallPaint;
  final Paint _roofPaint;
  final Paint _doorPaint;

  /// Restores the safehouse to full health.
  void resetHealth() {
    currentHealth = maxHealth;
  }

  @override
  void render(Canvas canvas) {
    final wallRect = Rect.fromLTWH(8, 22, size.x - 16, size.y - 22);
    final roofPath = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, 26)
      ..lineTo(0, 26)
      ..close();
    final doorRect = Rect.fromLTWH(size.x / 2 - 8, size.y - 24, 16, 24);

    canvas
      ..drawRect(wallRect, _wallPaint)
      ..drawPath(roofPath, _roofPaint)
      ..drawRect(doorRect, _doorPaint);
  }
}
