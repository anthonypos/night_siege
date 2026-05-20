---
title: Phase 1 Arena Bounds Requirement Finding
type: note
permalink: night-siege/planning/findings/phase-1-arena-bounds-requirement-finding
tags:
- night-siege
- phase-1
- movement
- bounds
---

# Phase 1 Arena Bounds Requirement Finding

During review of the Phase 1 plan, arena bounds appeared as optional, should-have, or stretch depending on the document. That conflicted with the player-facing checkpoint: a visible player that can immediately disappear off-screen makes the first movement build feel broken, even if keyboard input technically works.

## Observations
- [finding] Phase 1 bounds should be must-have instead of optional or stretch #bounds
- [requirement] The player should remain inside the visible viewport or configured arena during the Phase 1 checkpoint #phase-1
- [requirement] Bounds behavior should be covered by a component test at the arena edges #testing
- [rationale] Keeping the placeholder visible protects the first playable checkpoint before camera or map systems exist #gameplay

## Relations
- relates_to [[Night Siege Project Context]]
- updates [[Phased Roadmap]]
- updates [[One Week Development Plan]]
