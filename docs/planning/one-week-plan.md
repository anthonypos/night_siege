# One Week Development Plan

This schedule assumes one focused week to produce a playable vertical slice. Each day should end with a runnable build.

## Day 1 - Boot Shell And Movement

Main goal:

- Complete Phase 0 first, then complete Phase 1 player movement.

Deliverables:

- Flutter app launches.
- Flame dependency added with `flutter pub add flame`.
- `lib/main.dart` uses `GameWidget`.
- `NightSiegeGame` exists.
- Plain background or placeholder scene renders before gameplay is added.
- `PlayerComponent` renders.
- WASD and arrow-key movement works.

Checkpoints:

- Phase 0: Flame shell launches with no player movement, zombies, HUD, safehouse, assets, or map tooling.
- Can launch with `flutter run`.
- `flutter analyze` and `flutter test` pass.
- Movement uses `dt`.
- Diagonal movement is not faster than cardinal movement.
- Phase 1: Player movement works while zombies, combat, HUD, safehouse, assets, and map tooling remain out of scope.

Do not spend time on:

- Art.
- Audio.
- Menus.
- Gameplay folders beyond the current phase.
- Mobile controls.
- Safehouse, HUD, zombies, combat, assets, or map tooling.

Stretch only if ahead:

- Simple arena bounds.

## Day 2 - Safehouse And HUD

Main goal:

- Give the player something to protect.

Deliverables:

- Safehouse component.
- Safehouse health.
- HUD with safehouse health, ammo, wood, and phase/wave label.
- Restart method stub or basic restart.

Checkpoints:

- Safehouse is visually obvious.
- HUD values are readable.
- Restart can reset the run state during development.

Do not spend time on:

- UI styling.
- Full menu flow.
- Animated HUD.

Stretch only if ahead:

- Game over overlay.

## Day 3 - Zombies And Shooting

Main goal:

- Create the first real survival pressure.

Deliverables:

- Zombie component.
- Timed zombie spawning.
- Basic zombie movement.
- Shooting with ammo.
- Bullets damage and kill zombies.
- Zombies damage safehouse.

Checkpoints:

- A 60-second test is playable.
- Zombies are readable.
- Player can run out of ammo.
- Safehouse can be destroyed.

Do not spend time on:

- Pathfinding.
- Multiple weapons.
- Multiple zombie types.

Stretch only if ahead:

- Hit flash.

## Day 4 - Barricades

Main goal:

- Add resource-driven defense decisions.

Deliverables:

- Wood spending.
- Barricade placement.
- Barricade health.
- Zombies damage barricades.
- Destroyed barricades are removed.

Checkpoints:

- Barricades clearly delay zombies.
- Wood scarcity matters.
- Placement is simple and predictable.

Do not spend time on:

- Build menus.
- Grid placement.
- Many defense types.

Stretch only if ahead:

- Simple repair interaction.

## Day 5 - Day/Night And Scavenging

Main goal:

- Complete the core loop.

Deliverables:

- Phase model.
- Day/prep phase.
- Night/attack phase.
- Ammo and wood loot pickups.
- Night escalation.
- Dawn transition.

Checkpoints:

- Player can prepare before an attack.
- The night feels more dangerous than the day.
- A second night starts cleanly.

Do not spend time on:

- Large exploration map.
- Food.
- Complex loot tables.

Stretch only if ahead:

- Simple day/night tint.

## Day 6 - Balance And Win/Loss

Main goal:

- Make the run complete and tense.

Deliverables:

- Configured number of nights.
- Victory condition.
- Game over condition.
- Restart from both outcomes.
- Tuned spawn rates, ammo, wood, barricade health, and safehouse health.

Checkpoints:

- The game can be won.
- The game can be lost.
- The player usually survives night one and struggles later.

Do not spend time on:

- New major mechanics.
- New content categories.
- Complex UI.

Stretch only if ahead:

- Screen shake or sound effects.

## Day 7 - Polish And Stabilization

Main goal:

- Improve readability, tension, and reliability.

Deliverables:

- Clear phase transitions.
- Basic feedback for hits and safehouse damage.
- Final balancing pass.
- Bug fixes.
- Playable packaged build or reliable run command.

Checkpoints:

- A fresh player can understand the loop.
- A full run takes a reasonable amount of time.
- No normal-run crashes.
- Restart works repeatedly.

Do not spend time on:

- Any new system that could destabilize the build.
- Major refactors.
- Art replacement unless geometry is unreadable.

Stretch only if ahead:

- One passive survivor card, and only if it is very small.
