import 'dart:ui';

import 'package:flame/game.dart';

class NightSiegeGame extends FlameGame {
  static final Paint _backgroundPaint = Paint()
    ..color = const Color(0xFF101820);

  @override
  Color backgroundColor() => const Color(0xFF101820);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _backgroundPaint);
    super.render(canvas);
  }
}
