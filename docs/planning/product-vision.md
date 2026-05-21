# Product Vision

Night Siege is a small isometric 2.5D zombie survival/base-defense game built with Flutter and Flame. The player scavenges during the day, returns to a fragile safehouse, spends scarce resources on defenses, and tries to survive escalating zombie attacks at night. This is a one-week vertical slice, so the goal is a focused playable prototype rather than a broad content-complete game.

## Target Experience

The prototype should create the feeling: "I barely survived another night."

That means the game should feel:

- Claustrophobic.
- Tense.
- Resource-starved.
- Desperate.
- Satisfying when the player survives.

Tension should come from simple, readable pressure:

- Ammo runs low.
- Wood is limited.
- Barricades buy time but break.
- The safehouse is fragile.
- More zombies arrive each night.
- Daytime decisions affect nighttime survival.

## Essential Fantasy Systems

The survival fantasy requires only a small set of systems:

- Player movement and basic combat.
- Isometric fake-3D presentation with simple 2D world-space rules.
- A safehouse with health.
- Zombies that move toward the player or safehouse.
- Ammo as a limited combat resource.
- Wood as a defense-building resource.
- Placeable barricades.
- Zombie damage against barricades and the safehouse.
- A day/night or wave loop that creates preparation and attack phases.
- HUD feedback for health, ammo, wood, phase, and outcome.
- Win/loss and restart flow.

These systems are enough to express the core fantasy. Everything else is secondary until the loop is playable and tense.

## Week One Non-Goals

Do not build these in week one:

- Open world exploration.
- Multiplayer.
- Complex crafting.
- Large inventory systems.
- Advanced AI or pathfinding.
- Procedural generation.
- Story cinematics.
- Fully simulated NPC companions.
- Large content scope.
- Multiple polished biomes or maps.
- Large art or animation pipelines.
- True 3D or camera tooling before the core loop works.

## Product Principles

- Keep the game playable after every phase.
- Prefer simple hardcoded values until tuning proves they need structure.
- Prefer placeholder geometry before art.
- Prioritize feel and clarity over architecture purity.
- Add polish only after the core loop works.
- Cut aggressively when a feature threatens the playable loop.

## Success Criteria

The vertical slice succeeds when a new player can:

1. Move around the play space.
2. Understand the safehouse must be protected.
3. Collect or manage ammo and wood.
4. Place barricades.
5. Shoot zombies.
6. Survive or fail during the night.
7. Restart quickly.

The prototype does not need to look final. It needs to play clearly.
