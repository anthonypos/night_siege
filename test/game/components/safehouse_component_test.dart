import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:night_siege/game/components/safehouse_component.dart';
import 'package:night_siege/game/geometry/isometric_projection.dart';

const double _epsilon = 0.0001;
final _projection = IsometricProjection(
  tileSize: Vector2(64, 32),
  origin: Vector2(320, 40),
);

void main() {
  group('SafehouseComponent', () {
    test('starts with current health equal to max health', () {
      final safehouse = SafehouseComponent(maxHealth: 125);

      expect(safehouse.maxHealth, 125);
      expect(safehouse.currentHealth, 125);
    });

    test('resetHealth restores current health to max health', () {
      final safehouse = SafehouseComponent(maxHealth: 100)..currentHealth = 12;

      safehouse.resetHealth();

      expect(safehouse.currentHealth, 100);
    });

    test('updates projected position and depth priority', () {
      final worldPosition = Vector2(260, 180);
      final safehouse = SafehouseComponent(
        worldPosition: worldPosition,
        projection: _projection,
      );

      _expectVectorCloseTo(safehouse.worldPosition, worldPosition);
      _expectVectorCloseTo(
        safehouse.position,
        _projection.project(worldPosition),
      );
      expect(
        safehouse.priority,
        (_projection.depthKey(worldPosition) *
                SafehouseComponent.depthPriorityScale)
            .round(),
      );

      final nextProjection = IsometricProjection(
        tileSize: Vector2(48, 24),
        origin: Vector2(200, 30),
      );

      safehouse.updateProjectedPosition(projection: nextProjection);

      _expectVectorCloseTo(
        safehouse.position,
        nextProjection.project(worldPosition),
      );
      expect(
        safehouse.priority,
        (nextProjection.depthKey(worldPosition) *
                SafehouseComponent.depthPriorityScale)
            .round(),
      );
    });

    test('treats legacy position writes as world position updates', () {
      final safehouse = SafehouseComponent(
        worldPosition: Vector2(260, 180),
        projection: _projection,
      );
      final nextWorldPosition = Vector2(300, 220);

      safehouse.position = nextWorldPosition;

      _expectVectorCloseTo(safehouse.worldPosition, nextWorldPosition);
      _expectVectorCloseTo(
        safehouse.position,
        _projection.project(nextWorldPosition),
      );
    });
  });
}

void _expectVectorCloseTo(Vector2 actual, Vector2 expected) {
  expect(actual.x, closeTo(expected.x, _epsilon));
  expect(actual.y, closeTo(expected.y, _epsilon));
}
