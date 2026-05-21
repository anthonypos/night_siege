import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:night_siege/game/night_siege_game.dart';
import 'package:night_siege/game/models/resources.dart';

const double _epsilon = 0.0001;

void main() {
  test('restartRun resets player, safehouse, resources, and phase', () async {
    final game = NightSiegeGame();
    game.onGameResize(Vector2(800, 600));
    await game.onLoad();

    final initialRevision = game.hudRevision.value;
    game.player.worldPosition = Vector2(1, 1);
    game.safehouse.currentHealth = 1;
    game.safehouse.worldPosition = Vector2(8, 8);
    game.resources
      ..ammo = 0
      ..wood = 0;
    game.phaseLabel = 'Wave 1';

    game.restartRun();

    _expectVectorCloseTo(
      game.player.worldPosition,
      game.initialPlayerWorldPosition,
    );
    _expectVectorCloseTo(
      game.player.position,
      game.isometricProjection.project(game.initialPlayerWorldPosition),
    );
    _expectVectorCloseTo(
      game.safehouse.worldPosition,
      game.safehouseWorldPosition,
    );
    _expectVectorCloseTo(
      game.safehouse.position,
      game.isometricProjection.project(game.safehouseWorldPosition),
    );
    expect(game.safehouse.currentHealth, game.safehouse.maxHealth);
    expect(game.resources.ammo, Resources.starterAmmo);
    expect(game.resources.wood, Resources.starterWood);
    expect(game.phaseLabel, 'Prepare');
    expect(game.hudRevision.value, initialRevision + 1);
  });

  test(
    'projects starting anchors and arena corners into the viewport',
    () async {
      final viewportSize = Vector2(640, 360);
      final game = NightSiegeGame();
      game.onGameResize(viewportSize);
      await game.onLoad();
      final arenaSize = game.worldArenaSize;

      final worldPoints = <Vector2>[
        game.initialPlayerWorldPosition,
        game.safehouseWorldPosition,
        Vector2.zero(),
        Vector2(arenaSize.x, 0),
        arenaSize,
        Vector2(0, arenaSize.y),
      ];

      for (final worldPoint in worldPoints) {
        final projected = game.isometricProjection.project(worldPoint);

        expect(projected.x, greaterThanOrEqualTo(0));
        expect(projected.x, lessThanOrEqualTo(viewportSize.x));
        expect(projected.y, greaterThanOrEqualTo(0));
        expect(projected.y, lessThanOrEqualTo(viewportSize.y));
      }
    },
  );

  test('moving spatial components update relative depth priority', () async {
    final game = NightSiegeGame();
    game.onGameResize(Vector2(800, 600));
    await game.onLoad();

    game.player.worldPosition = Vector2(2, 2);
    game.safehouse.worldPosition = Vector2(8, 8);

    expect(game.player.priority, lessThan(game.safehouse.priority));

    game.player.worldPosition = Vector2(9, 9);

    expect(game.player.priority, greaterThan(game.safehouse.priority));
    _expectVectorCloseTo(
      game.player.position,
      game.isometricProjection.project(game.player.worldPosition),
    );
  });
}

void _expectVectorCloseTo(Vector2 actual, Vector2 expected) {
  expect(actual.x, closeTo(expected.x, _epsilon));
  expect(actual.y, closeTo(expected.y, _epsilon));
}
