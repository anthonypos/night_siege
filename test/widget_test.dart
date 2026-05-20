import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:night_siege/game/night_siege_game.dart';

void main() {
  testWidgets('renders the Night Siege game widget', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(GameWidget(game: NightSiegeGame()));

    expect(find.byType(GameWidget<NightSiegeGame>), findsOneWidget);
  });
}
