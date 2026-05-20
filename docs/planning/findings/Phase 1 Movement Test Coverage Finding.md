---
title: Phase 1 Movement Test Coverage Finding
type: note
permalink: night-siege/planning/findings/phase-1-movement-test-coverage-finding
tags:
- night-siege
- phase-1
- testing
- movement
---

# Phase 1 Movement Test Coverage Finding

During review of the Phase 1 plan, the movement requirements were strong in prose but weak as a verification plan. The docs required `dt`-based movement and normalized diagonal movement, yet the implementation path only had the existing Flame host smoke test. That would let a future Phase 1 implementation pass tests while still regressing the core feel of movement.

## Observations
- [finding] Phase 1 movement needs focused component tests, not only a `GameWidget` smoke test #testing
- [requirement] Tests should set player key state, call `update(dt)`, and assert the resulting position #movement
- [requirement] Tests should cover cardinal movement, normalized diagonal movement, stopped movement, and bounds behavior #phase-1
- [rationale] Movement feel is the foundation for later combat, scavenging, and base-defense interactions #gameplay

## Relations
- relates_to [[Night Siege Project Context]]
- updates [[First Implementation Guide]]
- updates [[Ticket Backlog]]
