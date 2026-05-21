import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:night_siege/game/night_siege_game.dart';
import 'package:night_siege/game/ui/hud_overlay.dart';

void main() {
  testWidgets('renders safehouse health, resources, and phase', (tester) async {
    final game = NightSiegeGame()
      ..safehouse.currentHealth = 85
      ..phaseLabel = 'Wave 1';
    game.resources
      ..ammo = 12
      ..wood = 7;

    await tester.pumpWidget(MaterialApp(home: HudOverlay(game: game)));

    expect(find.text('Safehouse 85 / 100'), findsOneWidget);
    expect(find.text('Ammo 12'), findsOneWidget);
    expect(find.text('Wood 7'), findsOneWidget);
    expect(find.text('Phase Wave 1'), findsOneWidget);
  });
}
