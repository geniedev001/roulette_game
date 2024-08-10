import 'package:flutter/material.dart';
import 'package:roulette_game/game.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Image.asset(
              'assets/sample.png',
              width: 450,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Game(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.redAccent,
              size: 30,
            ),
            label: const Text(
              'Start',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
