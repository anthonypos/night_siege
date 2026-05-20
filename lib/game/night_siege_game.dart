import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'components/player_component.dart';

/// Flame game root for the current Phase 1 playable checkpoint.
class NightSiegeGame extends FlameGame with KeyboardEvents {
  static final Paint _backgroundPaint = Paint()
    ..color = const Color(0xFF101820);

  /// Player placeholder controlled by keyboard input.
  late final PlayerComponent player;

  @override
  Color backgroundColor() => const Color(0xFF101820);

  @override
  Future<void> onLoad() async {
    player = PlayerComponent(arenaSize: size)..position = size / 2;
    await add(player);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (isLoaded) {
      player.updateArenaSize(size);
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    player.keysPressed = keysPressed;
    return KeyEventResult.handled;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _backgroundPaint);
    super.render(canvas);
  }
}
