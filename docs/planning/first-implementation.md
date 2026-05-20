# First Implementation Guide

This guide covers Phase 0 and Phase 1 only. Phase 0 stops at a runnable Flutter and Flame shell. Phase 1 adds the visible moving player.

## Phase 0 - Project Setup

If the repository is not already a Flutter project:

```powershell
flutter create .
```

Add Flame:

```powershell
flutter pub add flame
flutter pub get
```

Do not manually pin Flame in `pubspec.yaml`. Let `flutter pub add flame` choose the compatible version.

Run the project:

```powershell
flutter run
```

Use a specific desktop target if needed:

```powershell
flutter run -d windows
```

## Phase 0 File Structure

Create only:

```text
lib/
  main.dart
  game/
    night_siege_game.dart
```

Do not create player, zombie, safehouse, HUD, asset, map, or future gameplay folders in Phase 0.

## `lib/main.dart`

```dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/night_siege_game.dart';

void main() {
  runApp(GameWidget(game: NightSiegeGame()));
}
```

## `lib/game/night_siege_game.dart`

```dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class NightSiegeGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF101820);
}
```

## Phase 0 Checkpoint

Phase 0 is complete when:

- Flutter project exists and runs.
- Flame is added with `flutter pub add flame`.
- Flame is not manually pinned as `flame: ^1.0.0`.
- `lib/main.dart` uses `GameWidget`.
- `NightSiegeGame` exists.
- The game renders a plain background or placeholder scene.
- No player movement exists yet.
- No zombies, HUD, safehouse, assets, or map tooling exists yet.
- No gameplay folders exist beyond the minimal Phase 0 structure.
- `flutter analyze`, `flutter test`, and one chosen `flutter run` target pass.

Do not continue to Phase 1 until this checkpoint is true.

## Phase 1 File Structure

Add only the player component structure:

```text
lib/
  game/
    components/
      player_component.dart
```

## Phase 1 `lib/game/night_siege_game.dart`

```dart
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player_component.dart';

class NightSiegeGame extends FlameGame with KeyboardEvents {
  late final PlayerComponent player;

  @override
  Color backgroundColor() => const Color(0xFF101820);

  @override
  Future<void> onLoad() async {
    player = PlayerComponent()
      ..position = size / 2;
    add(player);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    player.keysPressed = keysPressed;
    return KeyEventResult.handled;
  }
}
```

## Phase 1 `lib/game/components/player_component.dart`

```dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerComponent extends RectangleComponent {
  PlayerComponent()
      : super(
          size: Vector2.all(28),
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFE8E2C8),
        );

  Set<LogicalKeyboardKey> keysPressed = {};

  static const double speed = 180;

  @override
  void update(double dt) {
    super.update(dt);

    final direction = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      direction.y -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      direction.y += 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      direction.x -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      direction.x += 1;
    }

    if (direction.length2 > 0) {
      position += direction.normalized() * speed * dt;
    }
  }
}
```

## First Playable Checkpoint

The first checkpoint is intentionally small:

- App launches.
- Flame game renders.
- Player placeholder appears.
- WASD and arrow keys move the player.
- Movement feels responsive.
- Movement is simple enough to test by direct key state and `dt`.
- The player is optionally clamped to the viewport or arena bounds.

Do not continue to safehouse, zombies, combat, HUD, resources, assets, or map tooling until this checkpoint is true.

## Phase 1 Follow-Up

After movement works:

1. Clamp the player inside the visible arena.
2. Tune movement speed.

Avoid camera systems, animation, sprites, mobile controls, map tooling, assets, or extra architecture at this stage.
