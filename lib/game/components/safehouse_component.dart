import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:night_siege/game/geometry/isometric_projection.dart';

/// Placeholder safehouse base with world-space position and resettable health.
class SafehouseComponent extends PositionComponent {
  /// Creates the safehouse placeholder at a bounded world anchor.
  ///
  /// The [position] argument is kept as a Phase 1/2 compatibility alias for
  /// [worldPosition]. New gameplay code should read and write [worldPosition].
  SafehouseComponent({
    Vector2? worldPosition,
    Vector2? position,
    IsometricProjection? projection,
    this.maxHealth = 100,
  }) : currentHealth = maxHealth,
       _worldPosition = (worldPosition ?? position ?? Vector2.zero()).clone(),
       _projection = projection ?? _defaultProjection,
       _footprintPaint = Paint()..color = const Color(0x66343238),
       _frontWallPaint = Paint()..color = const Color(0xFF8D7A61),
       _sideWallPaint = Paint()..color = const Color(0xFF6E604F),
       _roofPaint = Paint()..color = const Color(0xFFB86B4B),
       _doorPaint = Paint()..color = const Color(0xFF3B2A21),
       _edgePaint = Paint()
         ..color = const Color(0xFF2A2727)
         ..style = PaintingStyle.stroke
         ..strokeWidth = 1.5,
       super(size: Vector2(128, 96), anchor: const Anchor(0.5, 0.72)) {
    updateProjectedPosition();
  }

  /// Multiplier used to preserve fractional depth keys in Flame priorities.
  static const int depthPriorityScale = 1000;

  static final IsometricProjection _defaultProjection = IsometricProjection(
    tileSize: Vector2(64, 32),
  );

  /// Maximum structural health for the safehouse.
  final int maxHealth;

  /// Current structural health for the safehouse.
  int currentHealth;

  final Vector2 _worldPosition;
  IsometricProjection _projection;

  final Paint _footprintPaint;
  final Paint _frontWallPaint;
  final Paint _sideWallPaint;
  final Paint _roofPaint;
  final Paint _doorPaint;
  final Paint _edgePaint;

  /// Canonical gameplay position in world coordinates.
  Vector2 get worldPosition => _worldPosition.clone();

  set worldPosition(Vector2 worldPosition) {
    _worldPosition.setFrom(worldPosition);
    updateProjectedPosition();
  }

  /// Current projection used to derive Flame screen position and priority.
  IsometricProjection get projection => _projection;

  @override
  set position(Vector2 position) {
    worldPosition = position;
  }

  /// Restores the safehouse to full health.
  void resetHealth() {
    currentHealth = maxHealth;
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
    final centerX = size.x / 2;
    final groundY = size.y * 0.72;
    final leftBase = Offset(centerX - 46, groundY);
    final rightBase = Offset(centerX + 46, groundY);
    final frontBase = Offset(centerX, groundY + 20);
    final backBase = Offset(centerX, groundY - 20);
    final leftTop = leftBase.translate(0, -34);
    final rightTop = rightBase.translate(0, -34);
    final frontTop = frontBase.translate(0, -34);
    final backTop = backBase.translate(0, -34);

    final footprintPath = Path()
      ..moveTo(backBase.dx, backBase.dy)
      ..lineTo(rightBase.dx + 8, rightBase.dy)
      ..lineTo(frontBase.dx, frontBase.dy + 4)
      ..lineTo(leftBase.dx - 8, leftBase.dy)
      ..close();

    final sideWallPath = Path()
      ..moveTo(rightBase.dx, rightBase.dy)
      ..lineTo(backBase.dx, backBase.dy)
      ..lineTo(backTop.dx, backTop.dy)
      ..lineTo(rightTop.dx, rightTop.dy)
      ..close();

    final frontWallPath = Path()
      ..moveTo(leftBase.dx, leftBase.dy)
      ..lineTo(frontBase.dx, frontBase.dy)
      ..lineTo(rightBase.dx, rightBase.dy)
      ..lineTo(rightTop.dx, rightTop.dy)
      ..lineTo(frontTop.dx, frontTop.dy)
      ..lineTo(leftTop.dx, leftTop.dy)
      ..close();

    final roofPath = Path()
      ..moveTo(backTop.dx, backTop.dy - 20)
      ..lineTo(rightTop.dx + 10, rightTop.dy + 4)
      ..lineTo(frontTop.dx, frontTop.dy + 18)
      ..lineTo(leftTop.dx - 10, leftTop.dy + 4)
      ..close();

    final doorPath = Path()
      ..moveTo(centerX - 8, frontBase.dy - 2)
      ..lineTo(centerX + 8, frontBase.dy - 8)
      ..lineTo(centerX + 8, frontBase.dy - 28)
      ..lineTo(centerX - 8, frontBase.dy - 22)
      ..close();

    canvas
      ..drawPath(footprintPath, _footprintPaint)
      ..drawPath(sideWallPath, _sideWallPaint)
      ..drawPath(sideWallPath, _edgePaint)
      ..drawPath(frontWallPath, _frontWallPaint)
      ..drawPath(frontWallPath, _edgePaint)
      ..drawPath(roofPath, _roofPaint)
      ..drawPath(roofPath, _edgePaint)
      ..drawPath(doorPath, _doorPaint)
      ..drawPath(doorPath, _edgePaint);
  }
}
