import 'package:flutter/material.dart';

class StartButton extends StatefulWidget {
  const StartButton({super.key});

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  static const _delayDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    Future.delayed(-_delayDuration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ),);
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
