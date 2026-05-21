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
- Player remains inside the visible arena.
- Component tests cover Phase 1 movement and bounds behavior.
- Phase 1: Player movement works while zombies, combat, HUD, safehouse, assets, and map tooling remain out of scope.

Do not spend time on:

- Art.
- Audio.
- Menus.
- Gameplay folders beyond the current phase.
- Mobile controls.
- Safehouse, HUD, zombies, combat, assets, or map tooling.

Stretch only if ahead:

- Movement speed tuning after the tested movement baseline feels correct.

## Day 2 - Safehouse And HUD

Main goal:

- Give the player something to protect.

Deliverables:

- Safehouse component.
- Safehouse health.
- Starter ammo and wood counters.
- HUD with safehouse health, ammo, wood, and a simple phase/wave label.
- Restart baseline for the current Phase 2 state.

Checkpoints:

- Safehouse is visually obvious.
- HUD values are readable.
- Restart resets player position, safehouse health, starter resources, and the phase/wave label.
- No zombies, combat, barricades, loot, day/night timer, or full game-over flow exists yet.

Do not spend time on:

- UI styling.
- Full menu flow.
- Animated HUD.

Stretch only if ahead:

- A game-over overlay shell only if it does not add real failure behavior before zombies exist.

## Day 3 - Isometric 2.5D Refactor

Main goal:

- Pivot the presentation before combat systems depend on flat top-down assumptions.

Deliverables:

- Isometric projection helper.
- Player and safehouse use explicit world-space positions.
- Player and safehouse render as readable fake-height placeholders.
- Depth sorting for spatial components.
- Movement, safehouse state, HUD, and restart tests still pass.

Checkpoints:

- The game still plays with the same WASD and arrow-key movement behavior.
- The HUD remains a Flutter overlay.
- The safehouse and player read as objects with footprint and height.
- No zombies, combat, barricades, loot, day/night timer, assets, or new packages are added yet.

Do not spend time on:

- True 3D.
- New rendering packages.
- Asset production.
- Camera complexity.
- Tile maps.

Stretch only if ahead:

- Slight projection tuning for readability after the tests are stable.

## Day 4 - Zombies And Shooting

Main goal:

- Create the first real survival pressure.

Deliverables:

- Zombie component.
- Timed zombie spawning.
- Basic zombie movement.
- Shooting with ammo.
- Bullets damage and kill zombies.
- Zombies damage safehouse.
- Safehouse reaching zero health triggers a restartable failure state.

Checkpoints:

- A 60-second test is playable.
- Zombies are readable.
- Player can run out of ammo.
- Safehouse can be destroyed and the run can restart from failure.

Do not spend time on:

- Pathfinding.
- Multiple weapons.
- Multiple zombie types.

Stretch only if ahead:

- Hit flash.

## Day 5 - Barricades

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

## Day 6 - Day/Night, Scavenging, And Outcomes

Main goal:

- Complete the core loop and make the run end cleanly.

Deliverables:

- Phase model.
- Day/prep phase.
- Night/attack phase.
- Ammo and wood loot pickups.
- Night escalation.
- Dawn transition.
- Configured number of nights.
- Victory condition.
- Game over condition.
- Restart from both outcomes.

Checkpoints:

- Player can prepare before an attack.
- The night feels more dangerous than the day.
- A second night starts cleanly.
- The game can be won.
- The game can be lost.
- Restart works from loss and victory.

Do not spend time on:

- Large exploration map.
- Food.
- Complex loot tables.
- New content categories.
- Complex UI.

Stretch only if ahead:

- Simple day/night tint.

## Day 7 - Polish And Stabilization

Main goal:

- Improve readability, tension, and reliability.

Deliverables:

- Clear phase transitions.
- Basic feedback for hits and safehouse damage.
- Final balancing pass.
- Bug fixes.
- Playable packaged build or reliable run command.
- Tuned spawn rates, ammo, wood, barricade health, and safehouse health.

Checkpoints:

- The player usually survives night one and struggles later.
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
