import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Ground extends RectangleComponent with CollisionCallbacks {
  Ground({required Vector2 position, required double width}) {
    this.position = position;
    size = Vector2(width, 20);
    paint.color = const Color(0xFF6B4F00); // Brown color for ground
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }
}
