import 'package:flutter/material.dart';
import 'Mario.dart';

class WinScreen extends StatelessWidget {
  final MarioGame game;

  const WinScreen(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You Win!',
            style: TextStyle(
              fontSize: 200,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              game.restart(); // Restarts the game when the button is pressed.
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
