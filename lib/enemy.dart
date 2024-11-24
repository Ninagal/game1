import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

// set the enemy class
class Enemy extends SpriteComponent with CollisionCallbacks, HasGameRef {
  Vector2 velocity = Vector2.zero();
  final double speed = 100; // Speed of the enemy
  late Timer _directionChangeTimer;
  final Random _random = Random();

  Enemy({required Vector2 position})
      : super(position: position, size: Vector2(50, 50)) {
    // Change direction every 2 seconds.
    _directionChangeTimer = Timer(2, onTick: _changeDirection, repeat: true);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // load the dragon
    sprite = await Sprite.load('dragon.png'); // Ensure it is in the correct assets folder.
    add(RectangleHitbox());
    _directionChangeTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Update position based on velocity
    position += velocity * dt;

    // Keep the enemy within the game screen bounds
    if (position.x < 0 || position.x + size.x > gameRef.size.x) {
      velocity.x = -velocity.x; // Reverse direction on X axis if hitting horizontal bounds
    }
    if (position.y < 0 || position.y + size.y > gameRef.size.y) {
      velocity.y = -velocity.y; // Reverse direction on Y axis if hitting vertical bounds
    }

    _directionChangeTimer.update(dt);
  }

  void _changeDirection() {
    // Randomly change direction to up, down, left, or right.
    int direction = _random.nextInt(4); // Generates a number between 0 and 3.

    switch (direction) {
      case 0: // Move left
        velocity = Vector2(-speed, 0);
        break;
      case 1: // Move right
        velocity = Vector2(speed, 0);
        break;
      case 2: // Move up
        velocity = Vector2(0, -speed);
        break;
      case 3: // Move down
        velocity = Vector2(0, speed);
        break;
    }
  }
}
