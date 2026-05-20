# Technical Architecture

Night Siege should use a small Flame architecture centered on one game class and a few components. Keep the structure direct until the playable loop proves it needs more separation.

## Initial Folder Structure

Phase 0 starts minimal:

```text
lib/
  main.dart
  game/
    night_siege_game.dart
```

Phase 1 may add the player component:

```text
lib/
  game/
    components/
      player_component.dart
```

Do not create future folders until the phase needs them. Add folders incrementally as systems are implemented.

Likely later additions:

```text
lib/
  game/
    components/
      safehouse_component.dart
      zombie_component.dart
      barricade_component.dart
      bullet_component.dart
      loot_pickup_component.dart
    systems/
      zombie_spawner.dart
      day_night_controller.dart
    models/
      resources.dart
    enums/
      game_phase.dart
    ui/
      hud_overlay.dart
      game_over_overlay.dart
```

## Flame Architecture

Use a single `NightSiegeGame extends FlameGame` as the owner of runtime game state.

Responsibilities:

- Create and reset the run.
- Own phase, night number, resources, and win/loss state.
- Add and remove Flame components.
- Route input to the player.
- Coordinate spawners, phase timers, and HUD overlays.

Use Flame components for spatial objects:

- `PlayerComponent`
- `SafehouseComponent`
- `ZombieComponent`
- `BarricadeComponent`
- `BulletComponent`
- `LootPickupComponent`

Use plain Dart system classes only when a behavior is clearly not a visual component:

- `ZombieSpawner`
- `DayNightController`

Avoid adding a service locator, dependency injection framework, or state management package for week one.

## Input

Use Flame keyboard events starting in Phase 1, when player movement is introduced.

Required import:

```dart
import 'package:flame/events.dart';
```

In Phase 1, the game class should mix in `KeyboardEvents` and pass pressed keys to the player. Later phases may also route game actions such as shooting and placing barricades.

## Core Game Loop Structure

The game should run as a simple state machine:

```text
day -> dusk -> night -> dawn -> day
```

For the first playable version, a wave loop is acceptable:

```text
prepare -> attack -> survived -> prepare
```

Recommended phase responsibilities:

- `day`: Spawn loot, allow scavenging, no heavy zombie pressure.
- `dusk`: Short warning period and final build time.
- `night`: Spawn zombies, escalate pressure, resolve survival.
- `dawn`: Stop spawning, award survival, advance night count.
- `gameOver`: Stop gameplay actions and show restart.
- `victory`: Show success after configured nights.

## State And Data Flow

Keep state centralized in `NightSiegeGame`:

- `GamePhase phase`
- `int nightNumber`
- `Resources resources`
- `SafehouseComponent safehouse`
- collections for zombies, barricades, bullets, and loot

Components should ask the game to perform meaningful state changes:

- `spendWood(amount)`
- `spendAmmo(amount)`
- `damageSafehouse(amount)`
- `placeBarricade(position)`
- `spawnZombie(position)`
- `endRun()`
- `restartRun()`

This keeps gameplay rules visible and avoids hidden side effects.

## HUD And Screens

Use Flutter overlays through `GameWidget.overlayBuilderMap`.

Week-one overlays:

- `HudOverlay`: safehouse health, ammo, wood, phase, night.
- `GameOverOverlay`: outcome and restart button.
- Optional `StartOverlay`: only if needed.

Do not build a complex app router for week one.

## Asset Strategy

Start with geometric rendering:

- Player: small light rectangle or circle.
- Safehouse: larger muted rectangle.
- Zombies: dark green or red circles.
- Barricades: brown rectangles.
- Bullets: small bright circles.
- Loot: small colored squares.

Add image and audio assets only after the loop is playable.

When assets are added:

- Preload them in `onLoad`.
- Keep asset names flat and obvious.
- Avoid building an art pipeline during week one.

## Suggested Enums And Models

Add these only when needed:

```dart
enum GamePhase {
  day,
  dusk,
  night,
  dawn,
  gameOver,
  victory,
}
```

```dart
enum LootType {
  ammo,
  wood,
}
```

```dart
class Resources {
  Resources({
    required this.ammo,
    required this.wood,
  });

  int ammo;
  int wood;
}
```

Do not add food until there is a gameplay use for it.

## Intentionally Simple Systems

Keep these simple for week one:

- Zombie AI: direct steering toward the nearest valid target.
- Collision: simple distance or rectangle overlap checks.
- Combat: one weapon, one bullet type, fixed cooldown.
- Resources: integer counters.
- Barricades: fixed cost and fixed health.
- Loot: ammo and wood only.
- Map: one bounded arena.
- Difficulty: spawn rate and zombie count scaling.

## Systems That Can Scale Later

These can become more sophisticated after the vertical slice works:

- Pathfinding and obstacle navigation.
- Tile maps.
- Multiple zombie types.
- Multiple weapons.
- Inventory and crafting.
- Survivor cards.
- Traps.
- Procedural loot.
- Mobile controls.
- Real art and animation.
- Audio mixing and music.

Scaling these before the core loop is fun is dangerous.
