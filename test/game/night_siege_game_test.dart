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
    game.player.position = Vector2(20, 30);
    game.safehouse.currentHealth = 1;
    game.resources
      ..ammo = 0
      ..wood = 0;
    game.phaseLabel = 'Wave 1';

    game.restartRun();

    _expectVectorCloseTo(game.player.position, Vector2(400, 300));
    expect(game.safehouse.currentHealth, game.safehouse.maxHealth);
    expect(game.resources.ammo, Resources.starterAmmo);
    expect(game.resources.wood, Resources.starterWood);
    expect(game.phaseLabel, 'Prepare');
    expect(game.hudRevision.value, initialRevision + 1);
  });
}

void _expectVectorCloseTo(Vector2 actual, Vector2 expected) {
  expect(actual.x, closeTo(expected.x, _epsilon));
  expect(actual.y, closeTo(expected.y, _epsilon));
}
