import 'package:flame/components.dart';

/// Maps gameplay world coordinates into isometric screen offsets.
///
/// Gameplay state should continue to live in world coordinates. Use this helper
/// at render/component boundaries when translating world anchors and heights
/// into Flame positions.
class IsometricProjection {
  /// Creates an isometric projection using tile dimensions and screen offsets.
  IsometricProjection({
    required Vector2 tileSize,
    Vector2? origin,
    Vector2? heightOffset,
  }) : _tileSize = tileSize.clone(),
       _origin = origin?.clone() ?? Vector2.zero(),
       _heightOffset = heightOffset?.clone() ?? Vector2(0, -1);

  final Vector2 _tileSize;
  final Vector2 _origin;
  final Vector2 _heightOffset;

  /// The screen dimensions of one world tile.
  Vector2 get tileSize => _tileSize.clone();

  /// The screen-space offset applied after projecting the world position.
  Vector2 get origin => _origin.clone();

  /// The per-unit screen-space offset applied for rendered height.
  Vector2 get heightOffset => _heightOffset.clone();

  /// Projects a world anchor plus optional rendered height into screen space.
  Vector2 project(Vector2 worldPosition, {double height = 0}) {
    final halfTileWidth = _tileSize.x / 2;
    final halfTileHeight = _tileSize.y / 2;

    return Vector2(
      _origin.x +
          (worldPosition.x - worldPosition.y) * halfTileWidth +
          _heightOffset.x * height,
      _origin.y +
          (worldPosition.x + worldPosition.y) * halfTileHeight +
          _heightOffset.y * height,
    );
  }

  /// Returns the default painter ordering key for a world anchor.
  double depthKey(Vector2 worldPosition) => isometricDepthKey(worldPosition);
}

/// Returns a simple back-to-front ordering key for isometric world anchors.
double isometricDepthKey(Vector2 worldPosition) {
  return worldPosition.x + worldPosition.y;
}
