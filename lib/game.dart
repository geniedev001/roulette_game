import 'package:flutter/material.dart';
import 'package:roulette_game/game_content/game_title.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 4, 61, 6),
            Color.fromARGB(255, 8, 68, 2),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: _gameContent(),
    );
  }

  Widget _gameContent() {
    return const Stack(
      children: [
        GameTitle(),
        //_gameRouletteWheel(),
        //_gameActionRotate(),
        //_gameActionsReset(),
        // _gameStatistics(),
        // _gameBet(),
        //_coinDisplay(),
      ],
    );
  }
}
∂