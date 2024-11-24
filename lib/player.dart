import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'ground.dart';
import 'Mario.dart';
import 'enemy.dart';

class Player extends SpriteComponent with KeyboardHandler, CollisionCallbacks, HasGameRef<MarioGame> {
  Vector2 velocity = Vector2.zero();
  final double gravity = 800;
  final double jumpSpeed = -300;
  final double higherJumpSpeed = -450;
  bool isOnGround = false;
  int jumpCount = 0;

  Player() : super(size: Vector2(300, 300));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('unicorn.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isOnGround) {
      velocity.y += gravity * dt;
    }

    position += velocity * dt;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        velocity.x = 200;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        velocity.x = -200;
      }

      if (keysPressed.contains(LogicalKeyboardKey.space) && jumpCount < 2) {
        velocity.y = jumpSpeed;
        jumpCount++;
        isOnGround = false;
      }

      if (keysPressed.contains(LogicalKeyboardKey.enter) && !isOnGround) {
        velocity.y = higherJumpSpeed;
        jumpCount++;
      }
    }

    if (event is KeyUpEvent) {
      if (!keysPressed.contains(LogicalKeyboardKey.arrowRight) &&
          !keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        velocity.x = 0;
      }
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ground) {
      isOnGround = true;
      jumpCount = 0;
      velocity.y = 0;
    }

    // Check if the player collided with an enemy (dragon).
    if (other is Enemy) {
      gameRef.increaseDragonCounter(); // Increase the dragon counter.
      _showHittingEffect(other.position); // Show the hitting image at the enemy's position.
      other.removeFromParent(); // Remove the dragon from the game after being hit.
    }
  }

// Method to show a hitting effect at a specific position.
void _showHittingEffect(Vector2 position) async {
  final hitEffect = SpriteComponent()
    ..sprite = await Sprite.load('hit.png') // Ensure 'hit.png' is in the assets folder.
    ..size = Vector2(100, 100) // Set the size of the hit effect.
    ..position = position - Vector2(25, 25); // Center the hit effect over the enemy.

  gameRef.add(hitEffect);

  // Remove the hit effect after 0.5 seconds using Future.delayed.
  Future.delayed(const Duration(milliseconds: 500), () {
    hitEffect.removeFromParent();
  });
}

}
