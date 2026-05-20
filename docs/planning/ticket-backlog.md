# Ticket Backlog

Tickets are grouped by phase. Implement must-have tickets first. Do not start could-have work until the MVP loop is playable.

## Phase 0 - Project Setup

### P0-01 - Scaffold Flutter App

Description:

- Create or verify a runnable Flutter project.

Acceptance criteria:

- `flutter run` launches the app.
- The project has a working `lib/main.dart`.

Suggested files/classes:

- `lib/main.dart`

Dependencies:

- None.

Estimated effort:

- Small.

Priority:

- Must-have.

### P0-02 - Add Flame Dependency

Description:

- Add Flame using the Flutter command line.

Acceptance criteria:

- `flutter pub add flame` succeeds.
- `flutter pub get` succeeds.
- Flame imports resolve.
- Flame is not manually pinned as `flame: ^1.0.0`.

Suggested files/classes:

- `pubspec.yaml`

Dependencies:

- P0-01.

Estimated effort:

- Small.

Priority:

- Must-have.

### P0-03 - Create Minimal Game Structure

Description:

- Create only the files required for the runnable Flame shell.

Acceptance criteria:

- Structure exists:

```text
lib/main.dart
lib/game/night_siege_game.dart
```

- `lib/main.dart` uses `GameWidget`.
- `NightSiegeGame` exists.
- The game renders a plain background or placeholder scene.
- No player movement exists yet.
- No zombies, HUD, safehouse, assets, or map tooling exists yet.
- No gameplay folders are created beyond the minimal Phase 0 structure.
- `flutter analyze`, `flutter test`, and one chosen `flutter run` target pass.

Suggested files/classes:

- `NightSiegeGame`

Dependencies:

- P0-02.

Estimated effort:

- Small.

Priority:

- Must-have.

## Phase 1 - Core Player Movement

Phase 1 ends when the player placeholder is visible and moves smoothly. Do not add zombies, combat, HUD, safehouse, assets, or map tooling in this phase.

### P1-01 - Render Player Component

Description:

- Add a visible placeholder player using simple geometric rendering.

Acceptance criteria:

- Player appears near the center of the screen.
- Player uses placeholder geometry.
- No zombies, combat, HUD, safehouse, assets, or map tooling exists yet.

Suggested files/classes:

- `lib/game/components/player_component.dart`

Dependencies:

- P0-03.

Estimated effort:

- Small.

Priority:

- Must-have.

### P1-02 - Keyboard Movement

Description:

- Add WASD and arrow-key movement.

Acceptance criteria:

- Player moves in all four cardinal directions.
- Diagonal movement is normalized.
- Movement uses `dt`.
- Movement is smooth and testable.
- `KeyboardEvents` is imported with `import 'package:flame/events.dart';`.
- No zombies, combat, HUD, safehouse, assets, or map tooling exists yet.

Suggested files/classes:

- `lib/game/night_siege_game.dart`
- `lib/game/components/player_component.dart`

Dependencies:

- P1-01.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P1-03 - Optional Arena Bounds

Description:

- Optionally prevent the player from leaving the visible viewport or configured arena.

Acceptance criteria:

- Player remains inside the visible or configured arena.
- Bounds behavior feels predictable.

Suggested files/classes:

- `NightSiegeGame`
- `PlayerComponent`

Dependencies:

- P1-02.

Estimated effort:

- Small.

Priority:

- Should-have.

## Phase 2 - Safehouse And HUD

### P2-01 - Safehouse Component

Description:

- Add a central safehouse with health.

Acceptance criteria:

- Safehouse renders clearly.
- Safehouse tracks current and max health.

Suggested files/classes:

- `lib/game/components/safehouse_component.dart`

Dependencies:

- P1-02.

Estimated effort:

- Small.

Priority:

- Must-have.

### P2-02 - Basic HUD Overlay

Description:

- Show survival-critical information.

Acceptance criteria:

- HUD displays safehouse health.
- HUD displays ammo and wood.
- HUD displays current phase or wave state.

Suggested files/classes:

- `lib/game/ui/hud_overlay.dart`
- `NightSiegeGame`

Dependencies:

- P2-01.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P2-03 - Game Over And Restart

Description:

- Add a restartable failure state.

Acceptance criteria:

- Safehouse reaching zero health triggers game over.
- Restart resets player, safehouse, resources, zombies, barricades, and phase.

Suggested files/classes:

- `lib/game/ui/game_over_overlay.dart`
- `NightSiegeGame`

Dependencies:

- P2-01.

Estimated effort:

- Medium.

Priority:

- Must-have.

## Phase 3 - Zombies And Combat

### P3-01 - Zombie Component

Description:

- Add a zombie that moves toward a target.

Acceptance criteria:

- Zombie renders as placeholder geometry.
- Zombie moves toward the safehouse or player.
- Zombie has health.

Suggested files/classes:

- `lib/game/components/zombie_component.dart`

Dependencies:

- P2-01.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P3-02 - Zombie Spawner

Description:

- Spawn zombies from the edge of the arena.

Acceptance criteria:

- Zombies spawn over time.
- Spawn rate is tunable with simple constants.
- Spawner can be disabled outside the attack phase.

Suggested files/classes:

- `lib/game/systems/zombie_spawner.dart`
- `NightSiegeGame`

Dependencies:

- P3-01.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P3-03 - Shooting And Ammo

Description:

- Let the player shoot a simple projectile.

Acceptance criteria:

- Shooting consumes one ammo.
- Shooting has a cooldown.
- No shot fires when ammo is zero.
- Bullet travels in a readable direction.

Suggested files/classes:

- `lib/game/components/bullet_component.dart`
- `PlayerComponent`
- `NightSiegeGame`

Dependencies:

- P2-02.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P3-04 - Damage And Death

Description:

- Resolve bullet hits and zombie attacks.

Acceptance criteria:

- Bullets damage zombies.
- Zombies are removed when health reaches zero.
- Zombies damage the safehouse when close enough.
- Dead or expired components are removed.

Suggested files/classes:

- `ZombieComponent`
- `BulletComponent`
- `SafehouseComponent`
- `NightSiegeGame`

Dependencies:

- P3-01, P3-03.

Estimated effort:

- Medium.

Priority:

- Must-have.

## Phase 4 - Barricades And Base Defense

### P4-01 - Wood Resource

Description:

- Track wood as the defense-building resource.

Acceptance criteria:

- Wood starts at a useful test value.
- HUD displays wood.
- Game exposes a simple spend method.

Suggested files/classes:

- `lib/game/models/resources.dart`
- `NightSiegeGame`
- `HudOverlay`

Dependencies:

- P2-02.

Estimated effort:

- Small.

Priority:

- Must-have.

### P4-02 - Barricade Placement

Description:

- Place a barricade near the player with one key.

Acceptance criteria:

- Barricade placement costs wood.
- Placement fails when wood is insufficient.
- Barricade renders clearly.

Suggested files/classes:

- `lib/game/components/barricade_component.dart`
- `PlayerComponent`
- `NightSiegeGame`

Dependencies:

- P4-01.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P4-03 - Barricade Damage

Description:

- Zombies attack barricades that block or intercept them.

Acceptance criteria:

- Zombies can damage barricades.
- Barricades track health.
- Barricades are removed when destroyed.

Suggested files/classes:

- `BarricadeComponent`
- `ZombieComponent`

Dependencies:

- P4-02, P3-04.

Estimated effort:

- Medium.

Priority:

- Must-have.

## Phase 5 - Day/Night And Scavenging

### P5-01 - Game Phase Model

Description:

- Add a simple phase enum and phase state.

Acceptance criteria:

- Game knows current phase.
- HUD displays current phase.
- Code can branch on phase.

Suggested files/classes:

- `lib/game/enums/game_phase.dart`
- `NightSiegeGame`

Dependencies:

- P2-02.

Estimated effort:

- Small.

Priority:

- Must-have.

### P5-02 - Phase Timer

Description:

- Add timer-driven phase transitions.

Acceptance criteria:

- Day transitions to dusk.
- Dusk transitions to night.
- Night transitions to dawn or victory/loss.
- Dawn advances the night count.

Suggested files/classes:

- `lib/game/systems/day_night_controller.dart`
- `NightSiegeGame`

Dependencies:

- P5-01.

Estimated effort:

- Medium.

Priority:

- Should-have.

### P5-03 - Loot Pickups

Description:

- Add simple ammo and wood pickups.

Acceptance criteria:

- Loot spawns during day.
- Player collision collects loot.
- Ammo and wood counters update.

Suggested files/classes:

- `lib/game/components/loot_pickup_component.dart`

Dependencies:

- P5-01, P4-01.

Estimated effort:

- Medium.

Priority:

- Should-have.

### P5-04 - Night Escalation

Description:

- Increase pressure across nights.

Acceptance criteria:

- Later nights spawn more zombies or spawn them faster.
- Escalation uses simple constants.
- The game remains winnable.

Suggested files/classes:

- `ZombieSpawner`
- `DayNightController`

Dependencies:

- P3-02, P5-02.

Estimated effort:

- Small.

Priority:

- Must-have.

### P5-05 - Victory Condition

Description:

- End the run successfully after a fixed number of nights.

Acceptance criteria:

- Surviving the configured final night triggers victory.
- Victory state stops spawning.
- Restart works from victory.

Suggested files/classes:

- `NightSiegeGame`
- `game_over_overlay.dart` or `victory_overlay.dart`

Dependencies:

- P5-02.

Estimated effort:

- Small.

Priority:

- Must-have.

## Phase 6 - Atmosphere And Polish

### P6-01 - Combat Feedback

Description:

- Add readable feedback for hits and damage.

Acceptance criteria:

- Zombies visibly react when hit.
- Safehouse damage is noticeable.
- Feedback does not obscure gameplay.

Suggested files/classes:

- Existing components.

Dependencies:

- MVP combat loop.

Estimated effort:

- Medium.

Priority:

- Should-have.

### P6-02 - Phase Atmosphere

Description:

- Add simple visual tinting for day and night.

Acceptance criteria:

- Night looks more dangerous.
- Day remains readable.
- Tint is simple and cheap.

Suggested files/classes:

- `NightSiegeGame`
- HUD or overlay component.

Dependencies:

- P5-01.

Estimated effort:

- Small.

Priority:

- Should-have.

### P6-03 - Basic Sound Effects

Description:

- Add minimal sound effects for important actions.

Acceptance criteria:

- Shooting has a sound.
- Zombie hit or death has a sound.
- Safehouse damage has a sound.

Suggested files/classes:

- `assets/audio/`
- `NightSiegeGame`

Dependencies:

- Core loop playable.

Estimated effort:

- Medium.

Priority:

- Could-have.

## Phase 7 - Stretch Goals

### P7-01 - Barricade Repair

Description:

- Allow player to spend wood to repair damaged barricades.

Acceptance criteria:

- Repair costs wood.
- Repair target is clear.
- Repair cannot exceed max health.

Suggested files/classes:

- `BarricadeComponent`
- `PlayerComponent`

Dependencies:

- P4-03.

Estimated effort:

- Small.

Priority:

- Could-have.

### P7-02 - Spike Trap

Description:

- Add one simple trap type.

Acceptance criteria:

- Trap costs wood.
- Trap damages zombies.
- Trap is consumed or has limited durability.

Suggested files/classes:

- `trap_component.dart`

Dependencies:

- P4-02.

Estimated effort:

- Medium.

Priority:

- Could-have.

### P7-03 - One Survivor Card

Description:

- Add one passive survivor bonus without NPC simulation.

Acceptance criteria:

- Survivor exists as a passive card or status.
- Survivor gives one simple bonus.
- No companion movement or AI is added.

Suggested files/classes:

- `survivor_card.dart`
- HUD.

Dependencies:

- Core loop fun and stable.

Estimated effort:

- Medium.

Priority:

- Could-have.

## Won't-Have In Week One

### W1-01 - Full Inventory And Crafting

Description:

- Full item inventory, recipes, and crafting UI.

Priority:

- Won't-have.

### W1-02 - Open World Or Procedural Map

Description:

- Large world exploration or procedural generation.

Priority:

- Won't-have.

### W1-03 - Simulated NPC Companions

Description:

- Fully animated companion survivors with AI behavior.

Priority:

- Won't-have.
