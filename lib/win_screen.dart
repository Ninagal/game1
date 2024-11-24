import 'package:flutter/material.dart';
import 'game.dart';

class WinScreen extends StatelessWidget {
  final MarioGame game;

  const WinScreen(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You Win!',
            style: TextStyle(
              fontSize: 200,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              game.restart(); // Restarts the game when the button is pressed.
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
