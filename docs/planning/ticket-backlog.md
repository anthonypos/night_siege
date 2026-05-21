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
- Component tests cover cardinal movement, normalized diagonal movement, and stopped movement.
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

### P1-03 - Simple Arena Bounds

Description:

- Prevent the player from leaving the visible viewport or configured arena.

Acceptance criteria:

- Player remains inside the visible or configured arena.
- Bounds behavior feels predictable.
- Component tests cover clamping at the arena edges.

Suggested files/classes:

- `NightSiegeGame`
- `PlayerComponent`

Dependencies:

- P1-02.

Estimated effort:

- Small.

Priority:

- Must-have.

### P1-04 - Movement Test Coverage

Description:

- Add focused tests for the movement rules introduced in Phase 1.

Acceptance criteria:

- Tests assert cardinal movement uses `speed * dt`.
- Tests assert diagonal movement is not faster than cardinal movement.
- Tests assert the player does not drift when no movement keys are pressed.
- Tests assert bounds prevent the player from leaving the arena.
- `flutter test` passes.

Suggested files/classes:

- `test/game/components/player_component_test.dart`

Dependencies:

- P1-03.

Estimated effort:

- Small.

Priority:

- Must-have.

## Phase 2 - Safehouse And HUD

Phase 2 starts only after Phase 1 is fully complete, including movement tests and arena bounds. This phase adds the objective, starter HUD state, and a reset baseline. It does not add zombies, combat, barricades, loot, a day/night timer, or full win/loss overlays.

### P2-01 - Safehouse Component

Description:

- Add a central safehouse with health.

Acceptance criteria:

- Safehouse renders clearly.
- Safehouse tracks current and max health.

Suggested files/classes:

- `lib/game/components/safehouse_component.dart`

Dependencies:

- P1-04.

Estimated effort:

- Small.

Priority:

- Must-have.

### P2-02 - Basic HUD Overlay And Starter Resources

Description:

- Show survival-critical information and add the starter counters future systems will spend.

Acceptance criteria:

- HUD displays safehouse health.
- Game tracks starter ammo and wood as integer counters.
- HUD displays ammo and wood.
- HUD displays a simple phase or wave label, such as `Prepare`.
- The simple phase or wave label does not require the full `GamePhase` enum.

Suggested files/classes:

- `lib/game/models/resources.dart`
- `lib/game/ui/hud_overlay.dart`
- `NightSiegeGame`

Dependencies:

- P2-01.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P2-03 - Restart Baseline

Description:

- Add a restart method for the current Phase 2 run state.

Acceptance criteria:

- `restartRun()` resets the player position, safehouse health, starter resources, and phase or wave label.
- Restart logic does not reference zombies, barricades, bullets, loot, or other future systems before they exist.
- No game-over overlay is required in Phase 2.

Suggested files/classes:

- `NightSiegeGame`

Dependencies:

- P2-02.

Estimated effort:

- Medium.

Priority:

- Must-have.

## Phase 3 - Isometric 2.5D Refactor

Phase 3 pivots the presentation from flat top-down to isometric fake 3D before zombies and combat are added. Keep gameplay state in 2D world coordinates and treat the isometric view as a rendering/projection layer. This phase must choose the canonical world-position field, projection origin, and depth-sort contract that future spatial components will reuse.

### P3-01 - Isometric Projection Helper

Description:

- Add a small helper that converts 2D world coordinates into isometric screen coordinates using explicit projection constants and origin inputs.

Acceptance criteria:

- Projection math is isolated from gameplay rules.
- Projection accepts a configurable tile size and screen origin or viewport offset.
- World positions remain normal 2D vectors for movement, bounds, and future collision.
- Projection is deterministic and covered by focused tests for cardinal world directions, height offset, origin handling, and representative arena corners.
- Screen-to-world conversion is added only if Phase 3 needs it; if it is added, inverse behavior is covered by focused tests.
- No new packages or true 3D engine are introduced.

Suggested files/classes:

- `lib/game/geometry/isometric_projection.dart`
- `test/game/geometry/isometric_projection_test.dart`

Dependencies:

- P2-03.

Estimated effort:

- Small.

Priority:

- Must-have.

### P3-02 - World-Space Player And Safehouse Placement

Description:

- Convert player and safehouse placement to explicit `worldPosition` values that are rendered through the isometric projection.

Acceptance criteria:

- Player and safehouse use `worldPosition` as their canonical gameplay position.
- Flame `position` or custom render offsets are derived from projection and are not used as gameplay state.
- `NightSiegeGame` defines a bounded `worldArenaSize` separate from the current viewport size.
- Player movement still uses `dt`, normalized diagonal movement, and arena bounds.
- Player movement and clamping use world-space bounds.
- Safehouse keeps current and max health from Phase 2.
- `restartRun()` resets player world position, safehouse health, starter resources, and phase label.
- The projection origin or viewport offset keeps the restart position, safehouse position, and representative arena corners visible in tested viewport sizes.
- Existing Phase 1 and Phase 2 tests are updated without weakening behavior coverage.

Suggested files/classes:

- `NightSiegeGame`
- `PlayerComponent`
- `SafehouseComponent`

Dependencies:

- P3-01.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P3-03 - Isometric Placeholder Rendering And Depth Sorting

Description:

- Render the player and safehouse with simple fake-height geometry and draw world objects in depth order.

Acceptance criteria:

- Player and safehouse placeholders have readable footprint and height.
- Components behind other components render first based on a named depth key, defaulting to `worldPosition.x + worldPosition.y` unless implementation tests show a better simple key.
- Moving components update their Flame priority or central draw order when `worldPosition` changes.
- Tests cover at least two spatial objects swapping relative depth order after their world positions change.
- HUD remains a Flutter overlay and is not projected into world space.
- Rendering stays geometric; no assets, map tooling, or new packages are added.

Suggested files/classes:

- `NightSiegeGame`
- `PlayerComponent`
- `SafehouseComponent`

Dependencies:

- P3-02.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P3-04 - Documentation Alignment

Description:

- Align project documentation with the completed isometric pivot and Phase 3 contracts.

Acceptance criteria:

- Root README describes Night Siege as an isometric 2.5D prototype rather than a flat top-down game after the pivot lands.
- Phase 3 documentation names `worldPosition`, projection origin or viewport offset, and the chosen depth-sort key.
- Documentation stays clear that Phase 3 adds no zombies, combat, barricades, loot, assets, map tooling, true 3D, or new packages.

Suggested files/classes:

- `README.md`
- `docs/README.md`
- `docs/wiki/Night Siege Project Context.md`

Dependencies:

- P3-03.

Estimated effort:

- Small.

Priority:

- Must-have.

## Phase 4 - Zombies And Combat

### P4-01 - Zombie Component

Description:

- Add a zombie that moves toward a target.

Acceptance criteria:

- Zombie renders as isometric placeholder geometry.
- Zombie moves toward the safehouse or player in world space.
- Zombie has health.

Suggested files/classes:

- `lib/game/components/zombie_component.dart`

Dependencies:

- P3-03.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P4-02 - Zombie Spawner

Description:

- Spawn zombies from the edge of the arena.

Acceptance criteria:

- Zombies spawn over time.
- Spawn positions use world-space arena edges.
- Spawn rate is tunable with simple constants.
- Spawner can be disabled outside the attack phase.

Suggested files/classes:

- `lib/game/systems/zombie_spawner.dart`
- `NightSiegeGame`

Dependencies:

- P4-01.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P4-03 - Shooting And Ammo

Description:

- Let the player shoot a simple projectile.

Acceptance criteria:

- Shooting consumes one ammo.
- Shooting has a cooldown.
- No shot fires when ammo is zero.
- Bullet travels in a readable world-space direction and renders clearly in the isometric view.

Suggested files/classes:

- `lib/game/components/bullet_component.dart`
- `PlayerComponent`
- `NightSiegeGame`

Dependencies:

- P2-02, P3-03.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P4-04 - Damage And Death

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

- P4-01, P4-03.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P4-05 - Failure State And Restart From Loss

Description:

- Trigger a restartable failure state once zombies can damage the safehouse.

Acceptance criteria:

- Safehouse reaching zero health triggers game over.
- Game over stops zombie spawning, shooting, and damage updates.
- Restart resets player, safehouse, resources, zombies, bullets, and the current attack or wave state.
- Restart does not reference barricades or loot before those systems exist.

Suggested files/classes:

- `lib/game/ui/game_over_overlay.dart`
- `NightSiegeGame`
- `SafehouseComponent`

Dependencies:

- P4-04.

Estimated effort:

- Medium.

Priority:

- Must-have.

## Phase 5 - Barricades And Base Defense

### P5-01 - Wood Spending

Description:

- Turn the existing wood counter into a spendable defense-building resource.

Acceptance criteria:

- Wood still starts at a useful test value.
- HUD displays updated wood after spending.
- Game exposes a simple `spendWood(amount)` method.
- Spending fails without changing wood when wood is insufficient.

Suggested files/classes:

- `NightSiegeGame`
- `HudOverlay`

Dependencies:

- P2-02.

Estimated effort:

- Small.

Priority:

- Must-have.

### P5-02 - Barricade Placement

Description:

- Place a barricade near the player with one key.

Acceptance criteria:

- Barricade placement costs wood.
- Placement uses world-space coordinates.
- Placement fails when wood is insufficient.
- Barricade renders clearly in the isometric view.

Suggested files/classes:

- `lib/game/components/barricade_component.dart`
- `PlayerComponent`
- `NightSiegeGame`

Dependencies:

- P5-01, P3-03.

Estimated effort:

- Medium.

Priority:

- Must-have.

### P5-03 - Barricade Damage

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

- P5-02, P4-04.

Estimated effort:

- Medium.

Priority:

- Must-have.

## Phase 6 - Day/Night And Scavenging

### P6-01 - Game Phase Model

Description:

- Add a simple phase enum and phase state.

Acceptance criteria:

- Game replaces or extends the Phase 2 phase/wave label with `GamePhase`.
- HUD displays current phase from `GamePhase`.
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

### P6-02 - Phase Timer

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

- P6-01.

Estimated effort:

- Medium.

Priority:

- Should-have.

### P6-03 - Loot Pickups

Description:

- Add simple ammo and wood pickups.

Acceptance criteria:

- Loot spawns during day.
- Loot uses world-space positions and renders clearly in the isometric view.
- Player collision collects loot.
- Ammo and wood counters update.

Suggested files/classes:

- `lib/game/components/loot_pickup_component.dart`

Dependencies:

- P6-01, P5-01.

Estimated effort:

- Medium.

Priority:

- Should-have.

### P6-04 - Night Escalation

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

- P4-02, P6-02.

Estimated effort:

- Small.

Priority:

- Must-have.

### P6-05 - Victory Condition

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

- P6-02.

Estimated effort:

- Small.

Priority:

- Must-have.

## Phase 7 - Atmosphere And Polish

### P7-01 - Combat Feedback

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

### P7-02 - Phase Atmosphere

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

- P6-01.

Estimated effort:

- Small.

Priority:

- Should-have.

### P7-03 - Basic Sound Effects

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

## Phase 8 - Stretch Goals

### P8-01 - Barricade Repair

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

- P5-03.

Estimated effort:

- Small.

Priority:

- Could-have.

### P8-02 - Spike Trap

Description:

- Add one simple trap type.

Acceptance criteria:

- Trap costs wood.
- Trap damages zombies.
- Trap is consumed or has limited durability.

Suggested files/classes:

- `trap_component.dart`

Dependencies:

- P5-02.

Estimated effort:

- Medium.

Priority:

- Could-have.

### P8-03 - One Survivor Card

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
