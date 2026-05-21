import 'package:flutter/material.dart';
import 'package:night_siege/game/night_siege_game.dart';

/// Displays the current run status above the Flame game canvas.
class HudOverlay extends StatelessWidget {
  /// Creates a HUD bound to the supplied game object.
  const HudOverlay({required this.game, super.key});

  /// Game instance that owns the values displayed by this overlay.
  final NightSiegeGame game;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: game.hudRevision,
      builder: (context, _) => _HudBody(snapshot: _HudSnapshot.fromGame(game)),
    );
  }
}

class _HudBody extends StatelessWidget {
  const _HudBody({required this.snapshot});

  final _HudSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xCC101820),
              border: Border.all(color: const Color(0x66F6E7CB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: DefaultTextStyle(
                style: textTheme.bodyMedium!.copyWith(
                  color: const Color(0xFFF6E7CB),
                  fontWeight: FontWeight.w700,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _HudMetric(
                      label: 'Safehouse',
                      value:
                          '${snapshot.safehouseHealth} / ${snapshot.safehouseMaxHealth}',
                    ),
                    _HudMetric(label: 'Ammo', value: '${snapshot.ammo}'),
                    _HudMetric(label: 'Wood', value: '${snapshot.wood}'),
                    _HudMetric(label: 'Phase', value: snapshot.phaseLabel),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HudMetric extends StatelessWidget {
  const _HudMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(label: '$label: $value', child: Text('$label $value'));
  }
}

class _HudSnapshot {
  const _HudSnapshot({
    required this.safehouseHealth,
    required this.safehouseMaxHealth,
    required this.ammo,
    required this.wood,
    required this.phaseLabel,
  });

  factory _HudSnapshot.fromGame(NightSiegeGame game) {
    return _HudSnapshot(
      safehouseHealth: game.safehouse.currentHealth,
      safehouseMaxHealth: game.safehouse.maxHealth,
      ammo: game.resources.ammo,
      wood: game.resources.wood,
      phaseLabel: game.phaseLabel,
    );
  }

  final int safehouseHealth;
  final int safehouseMaxHealth;
  final int ammo;
  final int wood;
  final String phaseLabel;
}
