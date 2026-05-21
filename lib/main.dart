import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/night_siege_game.dart';
import 'game/ui/hud_overlay.dart';

void main() {
  runApp(
    MaterialApp(
      home: GameWidget<NightSiegeGame>(
        game: NightSiegeGame(),
        overlayBuilderMap: {'hud': (context, game) => HudOverlay(game: game)},
        initialActiveOverlays: const ['hud'],
      ),
    ),
  );
}
