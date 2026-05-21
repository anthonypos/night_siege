/// Mutable run resources tracked by the game state.
class Resources {
  /// Creates a resources model with the given counters.
  Resources({required this.ammo, required this.wood});

  /// Creates the starter resources for a new run.
  factory Resources.starter() {
    return Resources(ammo: starterAmmo, wood: starterWood);
  }

  /// Starter ammo available at the beginning of a run.
  static const int starterAmmo = 12;

  /// Starter wood available at the beginning of a run.
  static const int starterWood = 20;

  /// Available ammunition.
  int ammo;

  /// Available wood.
  int wood;

  /// Restores counters to their starter values.
  void resetStarter() {
    ammo = starterAmmo;
    wood = starterWood;
  }
}
