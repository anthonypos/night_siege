# Phased Roadmap

The roadmap is ordered to keep the game playable at every step. Do not start later phases until the current phase has a working player-facing checkpoint.

## Phase 0 - Project Setup

Objective:

- Create a runnable Flutter and Flame project shell.

Why it matters:

- Removes environment and dependency risk before gameplay work begins.

User experience goal:

- The game window opens and renders a blank or simple scene.

Systems introduced:

- Flutter app entrypoint.
- Flame `GameWidget`.
- `NightSiegeGame`.

Technical risks:

- Flutter desktop/web target setup.
- Flame version compatibility.

Scope risks:

- Creating all future folders too early.
- Adding player movement, menus, assets, HUD, safehouse, or zombies before the shell is verified.

Acceptance criteria:

- Flutter project exists and runs.
- Flame is added using `flutter pub add flame`.
- Flame is not manually pinned as `flame: ^1.0.0`.
- `lib/main.dart` uses `GameWidget`.
- `NightSiegeGame` exists.
- The game renders a plain background or placeholder scene.
- No player movement exists yet.
- No zombies, HUD, safehouse, assets, or map tooling exists yet.
- No gameplay folders exist beyond the minimal Phase 0 structure.
- `flutter analyze`, `flutter test`, and one chosen `flutter run` target pass.

Estimated complexity:

- Low.

Suggested implementation order:

1. Create or verify Flutter project.
2. Run `flutter pub add flame`.
3. Create `lib/main.dart`.
4. Create `lib/game/night_siege_game.dart`.
5. Render a simple background or placeholder component.
6. Verify `flutter analyze`, `flutter test`, and one chosen `flutter run` target.

## Phase 1 - Core Player Movement

Objective:

- Add responsive keyboard-controlled player movement.

Why it matters:

- Movement feel is the foundation for every other system.

User experience goal:

- The player can move smoothly with WASD or arrow keys.

Systems introduced:

- `PlayerComponent`.
- Keyboard input.
- Optional viewport or arena bounds.

Technical risks:

- Keyboard events not reaching the game.
- Movement speed feeling too slow, too fast, or imprecise.
- Player leaving the useful play area.

Scope risks:

- Adding animation before movement feels right.
- Building mobile controls too early.
- Adding zombies, combat, HUD, safehouse, assets, or map tooling before movement is verified.

Acceptance criteria:

- `PlayerComponent` exists.
- A visible placeholder player renders.
- WASD and arrow key movement work.
- `KeyboardEvents` is imported with `import 'package:flame/events.dart';`.
- Player movement is smooth and testable.
- The player can optionally be clamped to the viewport or arena bounds.
- No zombies, combat, HUD, safehouse, assets, or map tooling exists yet.

Estimated complexity:

- Medium.

Suggested implementation order:

1. Create `lib/game/components/player_component.dart`.
2. Import `package:flame/events.dart` in the game file.
3. Add `KeyboardEvents` to `NightSiegeGame`.
4. Track pressed keys.
5. Move the player using normalized direction and `dt`.
6. Add simple arena or viewport bounds only if needed.

## Phase 2 - Safehouse And HUD

Objective:

- Add the defendable objective and basic player feedback.

Why it matters:

- The player needs a reason to care about zombies and defenses.

User experience goal:

- The player understands the safehouse must be protected.

Systems introduced:

- `SafehouseComponent`.
- Safehouse health.
- Basic HUD overlay.
- Restart-ready game state.

Technical risks:

- HUD not updating cleanly.
- Game state becoming scattered across components.

Scope risks:

- Overdesigning UI.
- Adding a menu system before the run loop works.

Estimated complexity:

- Medium.

Suggested implementation order:

1. Add safehouse component.
2. Give safehouse max health and current health.
3. Show safehouse health in HUD.
4. Add resources counters with starting ammo and wood.
5. Add restart method, even before game over is fully implemented.

## Phase 3 - Zombies And Combat

Objective:

- Add threat, shooting, damage, and zombie death.

Why it matters:

- This phase creates the first survival experience.

User experience goal:

- The player can shoot approaching zombies before they reach the safehouse.

Systems introduced:

- `ZombieComponent`.
- `ZombieSpawner`.
- `BulletComponent`.
- Ammo spending.
- Damage and death handling.

Technical risks:

- Collision bugs.
- Unbounded component growth.
- Zombies becoming unreadable or unfair.

Scope risks:

- Pathfinding.
- Multiple weapons.
- Multiple zombie types.

Estimated complexity:

- Medium.

Suggested implementation order:

1. Add one zombie moving toward the safehouse.
2. Add simple timed spawning from arena edges.
3. Add shooting with a cooldown.
4. Consume ammo per shot.
5. Add bullet-zombie collision.
6. Remove dead zombies and expired bullets.
7. Add zombie damage to safehouse.

## Phase 4 - Barricades And Base Defense

Objective:

- Let the player spend wood to place defenses.

Why it matters:

- Barricades turn scavenged resources into survival decisions.

User experience goal:

- The player can slow zombies with barricades, but defenses break under pressure.

Systems introduced:

- `BarricadeComponent`.
- Wood spending.
- Barricade placement.
- Barricade health.
- Zombie attack target selection.

Technical risks:

- Awkward placement.
- Zombies overlapping barricades.
- Barricades blocking the player in frustrating ways.

Scope risks:

- Grid building tools.
- Complex construction UI.
- Full repair system before basic placement works.

Estimated complexity:

- Medium.

Suggested implementation order:

1. Add wood counter if not already present.
2. Place barricade near the player with one key.
3. Spend fixed wood cost.
4. Prevent placement when wood is insufficient.
5. Make zombies damage barricades when close.
6. Remove destroyed barricades.
7. Tune barricade health and zombie damage.

## Phase 5 - Day/Night And Scavenging

Objective:

- Complete the core loop by connecting preparation and attack phases.

Why it matters:

- This is where Night Siege becomes the intended game rather than a wave shooter.

User experience goal:

- The player scavenges by day, prepares before night, survives the attack, then repeats.

Systems introduced:

- `GamePhase`.
- `DayNightController`.
- Loot pickups.
- Night escalation.
- Win condition.

Technical risks:

- Phase bugs that leave the game stuck.
- Loot spawning in bad locations.
- Difficulty ramp becoming unfair.

Scope risks:

- Large map design.
- Too many resources.
- Simulated scavenging systems.

Estimated complexity:

- High.

Suggested implementation order:

1. Add `GamePhase`.
2. Add phase timer.
3. Spawn wood and ammo pickups during day.
4. Disable or reduce zombie spawning during day.
5. Increase spawning during night.
6. Advance night count at dawn.
7. Add victory after a fixed number of nights.

## Phase 6 - Atmosphere And Polish

Objective:

- Improve tension, readability, and impact.

Why it matters:

- Small feedback improvements can make the prototype feel much better without adding major scope.

User experience goal:

- Hits, danger, phase changes, and survival moments feel clear and tense.

Systems introduced:

- Hit flash.
- Simple screen shake.
- Day/night tint.
- Basic sound effects.
- Simple particles if time allows.

Technical risks:

- Polish work hiding gameplay bugs.
- Effects reducing clarity.

Scope risks:

- Art pass too early.
- Music systems.
- Too many particle variants.

Estimated complexity:

- Medium.

Suggested implementation order:

1. Add hit feedback.
2. Add safehouse damage feedback.
3. Add phase color tint.
4. Add minimal shoot/hit/damage sounds.
5. Add game over/victory polish.

## Phase 7 - Stretch Goals

Objective:

- Add one small system only if the core loop is already playable and tense.

Why it matters:

- Stretch systems should deepen the loop, not rescue it.

User experience goal:

- Add a small tactical decision or replay hook.

Candidate systems:

- Barricade repair.
- Spike trap.
- One passive survivor card.
- Additional zombie type.

Technical risks:

- Late bugs.
- Balance instability.

Scope risks:

- Turning one stretch feature into a new subsystem.

Estimated complexity:

- Variable.

Suggested implementation order:

1. Pick one stretch goal.
2. Build the simplest possible version.
3. Stop if it weakens clarity or stability.
