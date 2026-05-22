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
    geometry/
      isometric_projection.dart
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

## Perspective And World Coordinates

Night Siege should pivot to an isometric 2.5D presentation in Phase 3 while keeping gameplay rules simple and testable.

Use 2D world coordinates for gameplay:

- Movement.
- Bounds.
- Targeting.
- Collision checks.
- Spawn positions.
- Placement positions.

Use an isolated projection helper to convert world coordinates into isometric screen coordinates for rendering. Do not make gameplay systems reason directly about projected screen coordinates.

Phase 3 should introduce `worldPosition` as the canonical gameplay position for spatial components. Movement, bounds, targeting, collision, spawn positions, placement positions, and restart logic should read and write `worldPosition`. Flame `position` or any custom render offset should be treated as projected presentation state after the isometric pivot.

Use a bounded `worldArenaSize` separate from the current viewport size. `NightSiegeGame` should define a fixed projection origin or viewport offset that keeps the current player restart position, safehouse position, and representative arena corners visible in target viewports. A fixed offset is enough for Phase 3; do not add camera tooling before the core loop needs it.

Recommended projection shape:

```text
screenX = originX + (worldX - worldY) * tileWidth / 2
screenY = originY + (worldX + worldY) * tileHeight / 2 - heightOffset
```

The exact constants can be tuned, but they should live in one small helper rather than being scattered across components. Add screen-to-world conversion only when pointer placement or another Phase 3 behavior actually needs it.

Fake height should be represented as rendering geometry, not physics. A safehouse can have a footprint and wall height, while collisions and health still use simple 2D world-space values.

Depth sorting should draw lower/farther world objects first and higher/nearer objects later. Prefer a named sort key such as `worldDepth = worldPosition.x + worldPosition.y` unless implementation tests show a clearer simple rule. Update Flame priority or the central draw order whenever a moving component changes `worldPosition`, and cover depth-order swaps with focused tests. Add this before zombies so every future component inherits the same visual rule.

Avoid:

- True 3D engines.
- New rendering packages.
- Asset pipelines before geometric placeholders are readable.
- Coupling the HUD to world projection.

## Input

Use Flame keyboard events starting in Phase 1, when player movement is introduced.

Required import:

```dart
import 'package:flame/events.dart';
```

In Phase 1, the game class should mix in `KeyboardEvents` and pass pressed keys to the player. Later phases may also route game actions such as shooting and placing barricades.

Keep Phase 1 movement deterministic enough to test directly: set the player's pressed keys, call `update(dt)`, and assert the resulting position. The first movement checkpoint should also clamp the player to the visible arena so keyboard exploration cannot move the placeholder off-screen before later map or camera systems exist.

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

Keep state centralized in `NightSiegeGame` as systems are introduced:

- `GamePhase phase`
- `int nightNumber`
- `Resources resources`
- `SafehouseComponent safehouse`
- collections for zombies, barricades, bullets, and loot

Components should ask the game to perform meaningful state changes:

- `spendWood(amount)`
- `spendAmmo(amount)`
- `damageSafehouse(amount)`
- `fireBullet(direction)`
- `placeBarricade(position)`
- `spawnZombie(position)`
- `endRun()`
- `restartRun()`

This keeps gameplay rules visible and avoids hidden side effects. Any mutation that changes HUD-visible state should notify the HUD through the existing game-owned revision or the current project equivalent.

Starting in Phase 4, `NightSiegeGame` should also own the lifecycle of active combat components. Keep zombies and bullets in typed collections, or provide an equally deterministic child-query helper, so collision, cleanup, game-over stopping, and restart resets can be tested without relying on incidental render tree state.

Phase 2 can use a simple phase or wave label for HUD text before the day/night model exists. Phase 3 should keep that state intact while changing the world presentation. Add `GamePhase` when Phase 6 needs branchable phases and timer-driven transitions. `Resources` may be introduced in Phase 2 as starter ammo and wood counters; Phase 5 turns wood into a spendable defense-building resource.

## HUD And Screens

Use Flutter overlays through `GameWidget.overlayBuilderMap`.

Week-one overlays:

- `HudOverlay`: safehouse health, ammo, wood, phase, night.
- `GameOverOverlay`: outcome and restart button.
- Optional `StartOverlay`: only if needed.

Do not build a complex app router for week one.

In Phase 2, `HudOverlay` should show safehouse health, starter ammo, starter wood, and a simple phase or wave label. Add `GameOverOverlay` after a real loss condition exists, starting with zombies damaging the safehouse. Register the game-over overlay in `GameWidget.overlayBuilderMap`, let `NightSiegeGame` activate it when the run ends, and route its restart action back through `restartRun()`.

## Asset Strategy

Start with geometric rendering in the current perspective:

- Phase 1 and Phase 2: simple flat placeholders are acceptable.
- Phase 3 onward: use isometric fake-height placeholders.

Suggested Phase 3 placeholder language:

- Player: small upright marker with a diamond footprint.
- Safehouse: larger footprint with simple walls and roof height.
- Zombies: compact upright markers with clear hostile color.
- Barricades: low raised blocks on the isometric ground plane.
- Bullets: small bright marks projected through world space.
- Loot: small raised pickups with distinct ammo and wood colors.

Add image and audio assets only after the loop is playable.

When assets are added:

- Preload them in `onLoad`.
- Keep asset names flat and obvious.
- Avoid building an art pipeline during week one.

## Suggested Enums And Models

Add these only when needed. `Resources` can appear with the Phase 2 HUD because ammo and wood are already visible there. `GamePhase` should wait until Phase 6 unless an earlier implementation genuinely needs branchable phase state.

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
- Map: one bounded isometric arena.
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
