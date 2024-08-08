import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roulette_game/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/roulette_bg.jpeg'),
          fit: BoxFit.fill,
        ),
      ),
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
