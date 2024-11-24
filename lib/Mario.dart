import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';
import 'package:flame/timer.dart';
import 'package:flutter/material.dart';
import 'player.dart';
import 'enemy.dart';
import 'ground.dart';
import 'win_screen.dart';

class MarioGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late Player player;
  int dragonCounter = 0; // Tracks how many dragons the player has collected.
  int enemiesSpawned = 0; // Tracks the number of enemies that have spawned.
  final int maxEnemies = 30; // Maximum number of enemies to spawn.
  late Timer _spawnTimer;
  final Random _random = Random();
  late TextComponent dragonCounterText; // Text component for displaying the dragon counter.

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Register the WinScreen overlay.
    overlays.addEntry('WinScreen', (context, game) => WinScreen(this));

    // Load the background image.
    add(SpriteComponent()
      ..sprite = await loadSprite('forest.png')
      ..size = size);

    // Add the player.
    player = Player();
    add(player);

    // Add ground platforms.
    add(Ground(position: Vector2(0, size.y - 50), width: size.x));

    // Initialize the dragon counter text.
    dragonCounterText = TextComponent(
      text: 'Dragons: 0',
      position: Vector2(10, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          backgroundColor: Colors.yellow, // Sets the background color behind the text.
          color: Colors.black,            // Sets the text color.
          fontSize: 40,                   // Sets the font size.
        ),
      ),
    );
    add(dragonCounterText);

    // Initialize the spawn timer.
    _spawnTimer = Timer(
      _randomInterval(),
      onTick: _spawnEnemy,
      repeat: true,
    )..start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the spawn timer.
    _spawnTimer.update(dt);

    // Check if the player has collected 20 dragons.
    if (dragonCounter >= 20) {
      overlays.add('WinScreen');
      pauseEngine(); // Pause the game when the player wins.
    }
  }

  // Method to spawn an enemy at a random position at the top of the screen.
  void _spawnEnemy() {
    if (enemiesSpawned < maxEnemies) {
      double x = _random.nextDouble() * (size.x - 50); // Random x position within game bounds.
      double y = 0; // Start at the top of the screen.
      add(Enemy(position: Vector2(x, y)));
      enemiesSpawned++;
      
      _spawnTimer.stop();
      _spawnTimer = Timer(
        _randomInterval(),
        onTick: _spawnEnemy,
        repeat: true,
      )..start();
    }
  }

  // Generates a random time interval between 1 and 3 seconds.
  double _randomInterval() {
    return 1 + _random.nextDouble() * 2; // Between 1 and 3 seconds.
  }

  void increaseDragonCounter() {
    dragonCounter++;
    // Update the text component with the new counter value.
    dragonCounterText.text = 'Dragons: $dragonCounter';
    print('Dragons collected: $dragonCounter'); // Optional: For debugging.
  }

  // Method to restart the game, resetting the counter and removing the overlay.
  void restart() {
    dragonCounter = 0;
    enemiesSpawned = 0;
    overlays.remove('WinScreen');
    resumeEngine();
    player.position = Vector2(100, size.y - 150); // Reset the player's position.
    dragonCounterText.text = 'Dragons: 0'; // Reset the displayed counter.
    _spawnTimer = Timer(
      _randomInterval(),
      onTick: _spawnEnemy,
      repeat: true,
    )..start();
  }
}
