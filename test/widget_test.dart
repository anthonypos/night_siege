import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:night_siege/game/night_siege_game.dart';
import 'package:night_siege/game/ui/hud_overlay.dart';

void main() {
  testWidgets('renders the Night Siege game widget with HUD overlay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GameWidget<NightSiegeGame>(
          game: NightSiegeGame(),
          overlayBuilderMap: {'hud': (context, game) => HudOverlay(game: game)},
          initialActiveOverlays: const ['hud'],
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(GameWidget<NightSiegeGame>), findsOneWidget);
    expect(find.byType(HudOverlay), findsOneWidget);
  });
}
