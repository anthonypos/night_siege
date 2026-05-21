import 'package:flutter_test/flutter_test.dart';
import 'package:night_siege/game/components/safehouse_component.dart';

void main() {
  group('SafehouseComponent', () {
    test('starts with current health equal to max health', () {
      final safehouse = SafehouseComponent(maxHealth: 125);

      expect(safehouse.maxHealth, 125);
      expect(safehouse.currentHealth, 125);
    });

    test('resetHealth restores current health to max health', () {
      final safehouse = SafehouseComponent(maxHealth: 100)..currentHealth = 12;

      safehouse.resetHealth();

      expect(safehouse.currentHealth, 100);
    });
  });
}
