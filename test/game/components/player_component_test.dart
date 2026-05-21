import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:night_siege/game/components/player_component.dart';
import 'package:night_siege/game/geometry/isometric_projection.dart';

const double _epsilon = 0.0001;
final _projection = IsometricProjection(
  tileSize: Vector2(64, 32),
  origin: Vector2(320, 40),
);

void main() {
  group('PlayerComponent', () {
    test('moves by speed times dt for cardinal input', () {
      final cases =
          <({LogicalKeyboardKey key, Vector2 direction, String name})>[
            (
              key: LogicalKeyboardKey.keyW,
              direction: Vector2(0, -1),
              name: 'up',
            ),
            (
              key: LogicalKeyboardKey.keyS,
              direction: Vector2(0, 1),
              name: 'down',
            ),
            (
              key: LogicalKeyboardKey.keyA,
              direction: Vector2(-1, 0),
              name: 'left',
            ),
            (
              key: LogicalKeyboardKey.keyD,
              direction: Vector2(1, 0),
              name: 'right',
            ),
          ];

      for (final movementCase in cases) {
        final start = Vector2(250, 250);
        final player = PlayerComponent(
          worldPosition: start,
          arenaSize: Vector2.all(500),
          projection: _projection,
        );

        const dt = 0.25;
        player.keysPressed = {movementCase.key};
        player.update(dt);

        _expectVectorCloseTo(
          player.worldPosition,
          start + movementCase.direction * PlayerComponent.speed * dt,
          reason: 'Expected ${movementCase.name} movement to use speed * dt.',
        );
        _expectVectorCloseTo(
          player.position,
          _projection.project(player.worldPosition),
        );
      }
    });

    test('normalizes diagonal movement', () {
      final start = Vector2(250, 250);
      final player = PlayerComponent(
        worldPosition: start,
        arenaSize: Vector2.all(500),
        projection: _projection,
      );

      const dt = 0.5;
      player.keysPressed = {LogicalKeyboardKey.keyD, LogicalKeyboardKey.keyS};
      player.update(dt);

      final delta = player.worldPosition - start;
      final expectedDistance = PlayerComponent.speed * dt;
      final expectedAxisDistance = expectedDistance / math.sqrt(2);

      expect(delta.length, closeTo(expectedDistance, _epsilon));
      _expectVectorCloseTo(
        delta,
        Vector2(expectedAxisDistance, expectedAxisDistance),
      );
    });

    test('does not move when no movement keys are pressed', () {
      final player = PlayerComponent(
        worldPosition: Vector2(250, 250),
        arenaSize: Vector2.all(500),
        projection: _projection,
      );

      player.keysPressed = {LogicalKeyboardKey.keyD};
      player.update(0.25);
      final stoppedPosition = player.worldPosition;

      player.keysPressed = {};
      player.update(1);

      _expectVectorCloseTo(player.worldPosition, stoppedPosition);
    });

    test('clamps movement inside the world arena bounds', () {
      final arenaSize = Vector2(120, 90);

      final leftPlayer = PlayerComponent(
        worldPosition: Vector2(15, arenaSize.y / 2),
        arenaSize: arenaSize,
        projection: _projection,
      );
      final halfSize = leftPlayer.worldFootprintSize / 2;

      leftPlayer.keysPressed = {LogicalKeyboardKey.keyA};
      leftPlayer.update(10);
      _expectVectorCloseTo(
        leftPlayer.worldPosition,
        Vector2(halfSize.x, arenaSize.y / 2),
      );

      final rightPlayer = PlayerComponent(
        worldPosition: Vector2(arenaSize.x - 15, arenaSize.y / 2),
        arenaSize: arenaSize,
        projection: _projection,
      );
      rightPlayer.keysPressed = {LogicalKeyboardKey.keyD};
      rightPlayer.update(10);
      _expectVectorCloseTo(
        rightPlayer.worldPosition,
        Vector2(arenaSize.x - halfSize.x, arenaSize.y / 2),
      );

      final topPlayer = PlayerComponent(
        worldPosition: Vector2(arenaSize.x / 2, 15),
        arenaSize: arenaSize,
        projection: _projection,
      );
      topPlayer.keysPressed = {LogicalKeyboardKey.keyW};
      topPlayer.update(10);
      _expectVectorCloseTo(
        topPlayer.worldPosition,
        Vector2(arenaSize.x / 2, halfSize.y),
      );

      final bottomPlayer = PlayerComponent(
        worldPosition: Vector2(arenaSize.x / 2, arenaSize.y - 15),
        arenaSize: arenaSize,
        projection: _projection,
      );
      bottomPlayer.keysPressed = {LogicalKeyboardKey.keyS};
      bottomPlayer.update(10);
      _expectVectorCloseTo(
        bottomPlayer.worldPosition,
        Vector2(arenaSize.x / 2, arenaSize.y - halfSize.y),
      );
    });

    test('updates projected position and depth priority', () {
      final start = Vector2(240, 180);
      final player = PlayerComponent(
        worldPosition: start,
        arenaSize: Vector2.all(500),
        projection: _projection,
      );

      _expectVectorCloseTo(player.position, _projection.project(start));
      expect(
        player.priority,
        (_projection.depthKey(start) * PlayerComponent.depthPriorityScale)
            .round(),
      );

      final nextProjection = IsometricProjection(
        tileSize: Vector2(48, 24),
        origin: Vector2(200, 30),
      );

      player.updateProjectedPosition(projection: nextProjection);

      _expectVectorCloseTo(player.position, nextProjection.project(start));
      expect(
        player.priority,
        (nextProjection.depthKey(start) * PlayerComponent.depthPriorityScale)
            .round(),
      );
    });

    test('treats legacy position writes as world position updates', () {
      final player = PlayerComponent(
        worldPosition: Vector2(240, 180),
        arenaSize: Vector2.all(500),
        projection: _projection,
      );
      final nextWorldPosition = Vector2(260, 220);

      player.position = nextWorldPosition;

      _expectVectorCloseTo(player.worldPosition, nextWorldPosition);
      _expectVectorCloseTo(
        player.position,
        _projection.project(nextWorldPosition),
      );
    });
  });
}

void _expectVectorCloseTo(Vector2 actual, Vector2 expected, {String? reason}) {
  expect(actual.x, closeTo(expected.x, _epsilon), reason: reason);
  expect(actual.y, closeTo(expected.y, _epsilon), reason: reason);
}
