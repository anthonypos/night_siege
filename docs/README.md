# Night Siege Documentation

This folder contains the developer-facing planning docs for the Night Siege one-week vertical slice.

Night Siege is a small Flutter and Flame 2D top-down zombie survival/base-defense prototype. The project goal is a playable loop, not a commercial-scale game.

## Source Of Truth

- [Project Context](wiki/Night%20Siege%20Project%20Context.md): Basic Memory project context, preserved as the design source of truth.
- [Product Vision](planning/product-vision.md): What the prototype is trying to feel like, and what week one intentionally excludes.
- [Technical Architecture](planning/technical-architecture.md): Recommended Flame architecture, state flow, phase model, and intentionally simple systems.
- [Phased Roadmap](planning/phased-roadmap.md): Phase-by-phase epic implementation plan.
- [Ticket Backlog](planning/ticket-backlog.md): Developer-ready implementation tickets grouped by phase.
- [MVP Lock](planning/mvp-lock.md): The minimum viable feature set, cut list, and scope traps.
- [One Week Plan](planning/one-week-plan.md): Practical seven-day schedule.
- [First Implementation](planning/first-implementation.md): Phase 0 and Phase 1 startup guidance.

## Project Rule

Phase 0 ends at a runnable Flutter and Flame shell: `GameWidget`, `NightSiegeGame`, and a plain rendered scene. Phase 1 adds the visible moving player, keeps it inside the visible arena, and backs movement behavior with focused tests. Do not add safehouse, HUD, zombies, combat, assets, or map tooling before those checkpoints are complete.

Protect the core gameplay loop:

1. Scavenge during the day.
2. Return to the safehouse.
3. Build or repair defenses.
4. Survive the night attack.
5. Repeat.

If a feature does not strengthen this loop during week one, cut it or defer it.
