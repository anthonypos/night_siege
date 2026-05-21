# MVP Lock Definition

The MVP is locked around one question: can the player scavenge, prepare, defend, survive or fail, and restart?

If the answer is yes, the vertical slice is succeeding. If the answer is no, do not add new systems.

## Minimum Feature Set

The exact minimum feature set is:

- Player movement.
- Isometric 2.5D presentation using simple world-space projection.
- Safehouse with health.
- Zombies that spawn and move toward the player or safehouse.
- Basic shooting.
- Limited ammo.
- Wood resource.
- Placeable barricades.
- Zombie damage to barricades.
- Zombie damage to safehouse.
- Win/loss condition.
- HUD for safehouse health, ammo, wood, phase, and night.
- Restart flow.

The day/night cycle and loot pickups are strongly recommended because they express the intended loop. If time gets tight, use a simpler prepare/attack wave loop first, then rename and tune it into day/night.

## Safe Cuts

Cut these freely if the core loop is not yet fun:

- Barricade repair.
- Spike traps.
- Survivor cards.
- Multiple zombie types.
- Multiple weapons.
- Food resource.
- Sound effects.
- Particles.
- Screen shake.
- Detailed lighting.
- Mobile controls.
- Large map.
- Tile map.
- Start menu.
- Narrative content.

## Do Not Start Until Core Loop Is Fun

These features are dangerous before MVP lock:

- Inventory.
- Crafting recipes.
- Procedural generation.
- Advanced pathfinding.
- Companion NPCs.
- Complex survivor system.
- Weapon progression.
- Meta progression.
- Multiple maps.
- Real art production.

## Brutal Cut Order

If schedule slips, cut in this order:

1. Survivor card.
2. Spike trap.
3. Repair.
4. Audio.
5. Particles.
6. Screen shake.
7. Day/night visual tint.
8. Loot variety.
9. Large map.
10. Camera complexity.

Do not cut:

- Player movement.
- Safehouse health.
- Zombies.
- Combat.
- Ammo.
- Wood.
- Barricades.
- Loss/restart.

## Scope Traps

Avoid these common indie game traps:

- Building a map editor before there is a game.
- Adding inventory because resources feel too simple.
- Adding pathfinding because zombies get stuck.
- Adding more enemy types before one enemy is tuned.
- Polishing art before readability and pressure are solved.
- Building menus instead of restart flow.
- Turning survivors into NPCs.
- Treating architecture as a product feature.
- Letting the isometric pivot turn into true 3D, camera tooling, or an asset pipeline before the loop works.

## MVP Readiness Checklist

The MVP can be considered locked when:

- A complete run can be played from start to win or loss.
- The player can restart without relaunching.
- The isometric view is readable enough to understand player, safehouse, zombies, and barricades.
- Resource scarcity changes player behavior.
- Barricades noticeably improve survival odds.
- Zombies create pressure on the safehouse.
- The HUD explains what matters.
- The final night feels harder than the first.
- There are no known crashes in a normal run.
