import 'package:flutter/material.dart';
import 'package:roulette_game/game.dart';
import 'package:roulette_game/start_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _StartButtonState();
}

class _StartButtonState extends State<HomeScreen> {
  static const _delayDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    Future.delayed(-_delayDuration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const StartButton(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/roulette_App_3000.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
