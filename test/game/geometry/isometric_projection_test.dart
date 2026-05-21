import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:night_siege/game/geometry/isometric_projection.dart';

const double _epsilon = 0.0001;

void main() {
  group('IsometricProjection', () {
    test('projects cardinal world directions around the origin', () {
      final projection = IsometricProjection(tileSize: Vector2(64, 32));

      final cases = <({String name, Vector2 worldPosition, Vector2 expected})>[
        (
          name: 'origin',
          worldPosition: Vector2.zero(),
          expected: Vector2.zero(),
        ),
        (name: 'east', worldPosition: Vector2(1, 0), expected: Vector2(32, 16)),
        (
          name: 'south',
          worldPosition: Vector2(0, 1),
          expected: Vector2(-32, 16),
        ),
        (
          name: 'west',
          worldPosition: Vector2(-1, 0),
          expected: Vector2(-32, -16),
        ),
        (
          name: 'north',
          worldPosition: Vector2(0, -1),
          expected: Vector2(32, -16),
        ),
      ];

      for (final projectionCase in cases) {
        _expectVectorCloseTo(
          projection.project(projectionCase.worldPosition),
          projectionCase.expected,
          reason: 'Expected ${projectionCase.name} to project correctly.',
        );
      }
    });

    test('applies origin as a viewport offset', () {
      final projection = IsometricProjection(
        tileSize: Vector2(64, 32),
        origin: Vector2(400, 120),
      );

      _expectVectorCloseTo(
        projection.project(Vector2(2, 1)),
        Vector2(432, 168),
      );
    });

    test('applies height offset without changing the world anchor', () {
      final worldPosition = Vector2(1, 0);
      final projection = IsometricProjection(
        tileSize: Vector2(64, 32),
        heightOffset: Vector2(0, -12),
      );

      _expectVectorCloseTo(
        projection.project(worldPosition, height: 3),
        Vector2(32, -20),
      );
      _expectVectorCloseTo(worldPosition, Vector2(1, 0));
    });

    test('provides a simple named depth ordering key', () {
      final projection = IsometricProjection(tileSize: Vector2(64, 32));
      final worldPosition = Vector2(3, 4);

      expect(projection.depthKey(worldPosition), 7);
      expect(isometricDepthKey(worldPosition), 7);
    });

    test('keeps representative arena corners visible and spread out', () {
      final viewportSize = Vector2(640, 360);
      final arenaSize = Vector2(10, 10);
      final projection = IsometricProjection(
        tileSize: Vector2(64, 32),
        origin: Vector2(viewportSize.x / 2, 40),
      );

      final corners = <Vector2>[
        Vector2.zero(),
        Vector2(arenaSize.x, 0),
        Vector2(0, arenaSize.y),
        arenaSize,
      ];
      final projectedCorners = corners.map(projection.project).toList();
      final xs = projectedCorners.map((corner) => corner.x).toList();
      final ys = projectedCorners.map((corner) => corner.y).toList();

      expect(xs.reduce((a, b) => a < b ? a : b), closeTo(0, _epsilon));
      expect(
        xs.reduce((a, b) => a > b ? a : b),
        closeTo(viewportSize.x, _epsilon),
      );
      expect(ys.reduce((a, b) => a < b ? a : b), closeTo(40, _epsilon));
      expect(
        ys.reduce((a, b) => a > b ? a : b),
        closeTo(viewportSize.y, _epsilon),
      );
    });
  });
}

void _expectVectorCloseTo(Vector2 actual, Vector2 expected, {String? reason}) {
  expect(actual.x, closeTo(expected.x, _epsilon), reason: reason);
  expect(actual.y, closeTo(expected.y, _epsilon), reason: reason);
}
