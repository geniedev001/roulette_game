import 'package:flutter/material.dart';

class GameTitle extends StatefulWidget {
  const GameTitle({super.key});

  @override
  State<GameTitle> createState() => _GameTitleState();
}

class _GameTitleState extends State<GameTitle> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
    );
  }
}
