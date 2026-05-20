import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:night_siege/game/components/player_component.dart';

const double _epsilon = 0.0001;

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
          position: start,
          arenaSize: Vector2.all(500),
        );

        const dt = 0.25;
        player.keysPressed = {movementCase.key};
        player.update(dt);

        _expectVectorCloseTo(
          player.position,
          start + movementCase.direction * PlayerComponent.speed * dt,
          reason: 'Expected ${movementCase.name} movement to use speed * dt.',
        );
      }
    });

    test('normalizes diagonal movement', () {
      final start = Vector2(250, 250);
      final player = PlayerComponent(
        position: start,
        arenaSize: Vector2.all(500),
      );

      const dt = 0.5;
      player.keysPressed = {LogicalKeyboardKey.keyD, LogicalKeyboardKey.keyS};
      player.update(dt);

      final delta = player.position - start;
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
        position: Vector2(250, 250),
        arenaSize: Vector2.all(500),
      );

      player.keysPressed = {LogicalKeyboardKey.keyD};
      player.update(0.25);
      final stoppedPosition = player.position.clone();

      player.keysPressed = {};
      player.update(1);

      _expectVectorCloseTo(player.position, stoppedPosition);
    });

    test('clamps movement inside the visible arena bounds', () {
      final arenaSize = Vector2(120, 90);

      final leftPlayer = PlayerComponent(
        position: Vector2(15, arenaSize.y / 2),
        arenaSize: arenaSize,
      );
      final halfSize = leftPlayer.size / 2;

      leftPlayer.keysPressed = {LogicalKeyboardKey.keyA};
      leftPlayer.update(1);
      _expectVectorCloseTo(
        leftPlayer.position,
        Vector2(halfSize.x, arenaSize.y / 2),
      );

      final rightPlayer = PlayerComponent(
        position: Vector2(arenaSize.x - 15, arenaSize.y / 2),
        arenaSize: arenaSize,
      );
      rightPlayer.keysPressed = {LogicalKeyboardKey.keyD};
      rightPlayer.update(1);
      _expectVectorCloseTo(
        rightPlayer.position,
        Vector2(arenaSize.x - halfSize.x, arenaSize.y / 2),
      );

      final topPlayer = PlayerComponent(
        position: Vector2(arenaSize.x / 2, 15),
        arenaSize: arenaSize,
      );
      topPlayer.keysPressed = {LogicalKeyboardKey.keyW};
      topPlayer.update(1);
      _expectVectorCloseTo(
        topPlayer.position,
        Vector2(arenaSize.x / 2, halfSize.y),
      );

      final bottomPlayer = PlayerComponent(
        position: Vector2(arenaSize.x / 2, arenaSize.y - 15),
        arenaSize: arenaSize,
      );
      bottomPlayer.keysPressed = {LogicalKeyboardKey.keyS};
      bottomPlayer.update(1);
      _expectVectorCloseTo(
        bottomPlayer.position,
        Vector2(arenaSize.x / 2, arenaSize.y - halfSize.y),
      );
    });
  });
}

void _expectVectorCloseTo(Vector2 actual, Vector2 expected, {String? reason}) {
  expect(actual.x, closeTo(expected.x, _epsilon), reason: reason);
  expect(actual.y, closeTo(expected.y, _epsilon), reason: reason);
}
