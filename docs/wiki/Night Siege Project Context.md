---
title: Night Siege Project Context
type: project
permalink: night-siege/wiki/night-siege-project-context
status: active
date_ingested: '2026-05-19'
engine: Flutter + Flame
genre: 2D top-down zombie survival/base-defense
scope: one-week vertical slice
tags:
- night-siege
- game-design
- mvp
- flutter
- flame
- vertical-slice
---

# Night Siege Project Context

This note preserves the initial project context for Night Siege and distills it into structured design memory. Night Siege is a small Flutter/Flame 2D top-down zombie survival and base-defense game, scoped as a one-week vertical slice. The primary delivery goal is a playable, atmospheric prototype centered on scavenging, barricading, and surviving increasingly desperate nights.

## Source Content

# Night Siege — Basic Memory Project Context

## Project Overview

Night Siege is a small 2D top-down zombie survival/base-defense game built using Flutter and the Flame game engine.

The game is intended to be developed as a one-week vertical slice project focused on delivering a playable and atmospheric prototype rather than a large-scale feature-complete game.

Core gameplay loop:
1. Scavenge for supplies during the day.
2. Return to the safehouse.
3. Build or repair defenses.
4. Survive zombie attacks during the night.
5. Repeat for multiple nights.

Inspirations:
- The Walking Dead
- The Last of Us
- 28 Days Later
- Survival horror and zombie apocalypse media
- Base-defense gameplay loops

The tone should feel tense, desperate, and atmospheric.

---

# Technical Stack

## Engine & Framework
- Flutter
- Flame
- Dart

## Target Style
- 2D top-down
- Keyboard controls first
- Placeholder graphics initially
- Mobile support is optional/stretch goal

## Core Design Philosophy
- Keep the game playable at every stage
- Build a vertical slice first
- Prioritize game feel over technical complexity
- Avoid overengineering
- Add polish only after the gameplay loop works

---

# Week One MVP

The MVP is considered successful if the following systems are implemented and playable:

## Required Features
- Player movement
- Safehouse/base object with health
- Zombie spawning
- Zombie AI pathing toward player or safehouse
- Basic combat/shooting
- Ammo system
- Wood resource system
- Placeable barricades
- Zombie damage to barricades and safehouse
- Win/loss condition
- HUD/UI
- Restart flow

## Nice-to-Have Features
- Day/night cycle
- Loot pickups
- Barricade repair
- Spike traps
- Small playable map
- Basic sound effects
- Screen shake/particles
- One passive survivor card

## Explicit Non-Goals For Week One
- Open world
- Multiplayer
- Complex crafting
- Large inventory systems
- Advanced AI
- Procedural generation
- Story cinematics
- Fully simulated NPC companions
- Large content scope

---

# Initial Gameplay Vision

The player starts in or near a fragile safehouse.

During the day:
- Explore nearby abandoned areas
- Gather wood, ammo, and supplies
- Prepare defenses

During the night:
- Zombies attack the safehouse
- Barricades slow or block enemies
- Resources become scarce
- The player must survive until dawn

The game should create tension through:
- Limited resources
- Fragile defenses
- Increasing zombie pressure
- Risk/reward scavenging decisions

---

# Proposed Architecture

## Suggested Folder Structure

Phase 0:

```text
lib/
  main.dart
  game/
    night_siege_game.dart
```

Phase 1 may add:

```text
lib/
  game/
    components/
      player_component.dart
```

Later phases may add only when needed:

```text
lib/
  game/
    components/
      zombie/
      barricade/
      safehouse/
      loot/
      weapons/
      ui/
    systems/
      spawning/
      combat/
      daynight/
      resources/
    models/
    enums/
    screens/
    utils/

assets/
  images/
  audio/
  fonts/

docs/
  wiki/
```

---

# Core Systems

## Player
Responsibilities:
- Movement
- Combat
- Resource interaction
- Barricade placement

## Zombie System
Responsibilities:
- Spawning
- AI targeting
- Damage handling
- Escalating difficulty

## Safehouse System
Responsibilities:
- Central defendable structure
- Health tracking
- Loss condition

## Barricade System
Responsibilities:
- Placement
- Blocking/path interruption
- Damage/destruction
- Repair

## Day/Night System
Responsibilities:
- Switching gameplay phases
- Controlling zombie spawning
- Triggering scavenging/build phases

## Resource System
Resources:
- Ammo
- Wood
- Food (future use)

---

# Survivor System (Stretch Goal)

Survivors are NOT fully simulated NPCs initially.

Instead:
- Survivors exist as passive “cards”
- Each survivor provides a gameplay bonus

Examples:
- Good Shot: periodically damages zombies
- Mechanic: repairs barricades faster
- Scavenger: increases loot drops

This system exists to capture the “finding people and building a group” fantasy without large AI complexity.

---

# Development Approach

## Phase 0 — Setup
- Create Flutter project
- Install Flame with `flutter pub add flame`
- Create a Flutter `GameWidget`
- Create `NightSiegeGame`
- Render a plain background or placeholder scene
- Verify `flutter analyze`, `flutter test`, and one chosen `flutter run` target
- Do not add player movement, zombies, HUD, safehouse, assets, map tooling, or gameplay folders beyond the minimal shell

## Phase 1 — Core Player Movement
- Add `PlayerComponent`
- Render a visible placeholder player
- Player movement
- Keyboard input with `KeyboardEvents`
- Clamp player to simple viewport or arena bounds
- Add focused tests for `dt` movement, normalized diagonal movement, stopped movement, and bounds
- Do not add zombies, combat, HUD, safehouse, assets, or map tooling

## Phase 2 — Safehouse And HUD
- Safehouse
- HUD
- Restart-ready game state

## Phase 3 — Zombies & Combat
- Zombie spawning
- Basic AI
- Combat
- Health systems

## Phase 4 — Base Defense
- Barricades
- Resource usage
- Zombie damage/destruction

## Phase 5 — Scavenging Loop
- Day/night cycle
- Loot pickups
- Supply gathering

## Phase 6 — Atmosphere & Polish
- Audio
- Lighting
- Screen shake
- UI polish
- Game over/win screens

## Phase 7 — Stretch Goals
- Survivor cards
- Additional zombie types
- Traps
- Additional weapons

---

# Scope Rules

When making implementation decisions:
- Prefer simplicity over flexibility
- Prefer hardcoded values over premature configuration
- Avoid abstractions unless clearly useful
- Avoid plugin bloat
- Avoid large refactors during week one
- Keep systems small and testable

If a feature threatens delivery of the core gameplay loop, cut the feature.

The playable core loop is more important than completeness.

---

# Desired Feeling

The game should feel:
- Claustrophobic
- Tense
- Resource-starved
- Desperate
- Satisfying when surviving until dawn

The emotional fantasy is:
“I barely survived another night.”

## Observations
- [project] Night Siege is a small 2D top-down zombie survival/base-defense game built with Flutter, Flame, and Dart #night-siege
- [scope] Week one targets a playable vertical slice rather than a feature-complete game #mvp
- [loop] Core loop is daytime scavenging, safehouse return, defense building or repair, nighttime survival, then repeat #gameplay
- [tone] The intended tone is tense, desperate, claustrophobic, atmospheric, and resource-starved #atmosphere
- [priority] Keep the game playable at every stage and prioritize game feel over technical complexity #delivery
- [constraint] Avoid overengineering, plugin bloat, large refactors, and premature abstraction during week one #scope
- [phase] Phase 0 ends at a runnable Flutter and Flame shell with `GameWidget`, `NightSiegeGame`, and a plain rendered scene; it does not include player movement, zombies, HUD, safehouse, assets, or map tooling #delivery
- [phase] Phase 1 introduces `PlayerComponent`, a visible placeholder player, WASD and arrow-key movement through `KeyboardEvents`, simple arena bounds, and focused movement tests #player
- [requirement] MVP requires player movement, safehouse health, zombie spawning and AI, combat, ammo, wood, barricades, damage systems, win/loss conditions, HUD, and restart flow #mvp
- [stretch] Day/night cycle, loot pickups, repair, traps, small map, sound, screen shake, particles, and one survivor card are nice-to-have features #stretch
- [non_goal] Week one excludes open world, multiplayer, complex crafting, large inventory, advanced AI, procedural generation, cinematics, fully simulated NPCs, and large content scope #scope
- [architecture] Start with only `lib/main.dart` and `lib/game/night_siege_game.dart`; add `player_component.dart` in Phase 1 and later folders only when their phase needs them #architecture
- [system] Player responsibilities include movement, combat, resource interaction, and barricade placement #player
- [system] Zombie responsibilities include spawning, AI targeting, damage handling, and escalating difficulty #zombies
- [system] Safehouse responsibilities include being the central defendable object, tracking health, and driving loss conditions #safehouse
- [system] Barricade responsibilities include placement, blocking or slowing enemies, taking damage, destruction, and repair #barricades
- [system] Day/night responsibilities include phase switching, zombie spawn control, and scavenging/build phase triggers #daynight
- [system] Resources initially include ammo and wood, with food reserved for future use #resources
- [stretch] Survivors should start as passive cards with bonuses rather than fully simulated NPC companions #survivors
- [delivery] If a feature threatens delivery of the core gameplay loop, cut it #scope
- [fantasy] The desired emotional fantasy is: I barely survived another night #tone

## Relations
- defines [[Night Siege Week One MVP]]
- defines [[Night Siege Gameplay Loop]]
- defines [[Night Siege Scope Rules]]
- defines [[Night Siege Technical Stack]]
- defines [[Night Siege Architecture]]
- relates_to [[Player System]]
- relates_to [[Zombie System]]
- relates_to [[Safehouse System]]
- relates_to [[Barricade System]]
- relates_to [[Day Night System]]
- relates_to [[Resource System]]
- relates_to [[Survivor Card System]]
