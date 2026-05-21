import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'components/player_component.dart';
import 'components/safehouse_component.dart';
import 'models/resources.dart';

/// Flame game root for the current playable checkpoint.
class NightSiegeGame extends FlameGame with KeyboardEvents {
  /// Safehouse health used for the Phase 2 baseline.
  static const int safehouseMaxHealth = 100;

  /// Starter phase label shown before a fuller phase model exists.
  static const String initialPhaseLabel = 'Prepare';

  static final Paint _backgroundPaint = Paint()
    ..color = const Color(0xFF101820);

  /// Player placeholder controlled by keyboard input.
  late final PlayerComponent player;

  /// Safehouse placeholder tracked as the run's base.
  final SafehouseComponent safehouse = SafehouseComponent(
    maxHealth: safehouseMaxHealth,
  );

  /// Mutable resources for the current run.
  final Resources resources = Resources.starter();

  /// Current high-level phase label shown by UI surfaces.
  String phaseLabel = initialPhaseLabel;

  /// Revision notifier for HUDs that read game-owned state.
  final ValueNotifier<int> hudRevision = ValueNotifier<int>(0);

  @override
  Color backgroundColor() => const Color(0xFF101820);

  @override
  Future<void> onLoad() async {
    player = PlayerComponent(arenaSize: size)..position = size / 2;
    safehouse.position = _safehousePosition(size);
    await add(safehouse);
    await add(player);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (isLoaded) {
      player.updateArenaSize(size);
      safehouse.position = _safehousePosition(size);
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

  /// Resets run-scoped state to the Phase 2 starter values.
  void restartRun() {
    player
      ..position = size / 2
      ..keysPressed = {};
    safehouse
      ..position = _safehousePosition(size)
      ..resetHealth();
    resources.resetStarter();
    phaseLabel = initialPhaseLabel;
    hudRevision.value++;
  }

  @override
  void onRemove() {
    hudRevision.dispose();
    super.onRemove();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _backgroundPaint);
    super.render(canvas);
  }

  Vector2 _safehousePosition(Vector2 arenaSize) {
    return Vector2(arenaSize.x / 2, arenaSize.y * 0.32);
  }
}
