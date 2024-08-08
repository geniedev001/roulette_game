import 'dart:core';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  double bogenmass = 0;
  double coins = 5000;

  late AnimationController animationController;

  late Animation<double> animation;

  String SelectedColor = "green";

  int SelectedNumber = 0;
  int NumberRotations = 0;

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
    return Stack(
      children: [
        _gameTitle(),
        _gameRouletteWheel(),
        //_gameActionRotate(),
        //_gameActionsReset(),
        _gameStatistic(),
        // _gameBet(),
        _coinDisplay(),
      ],
    );
  }

  Widget _gameTitle() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 2,
          ),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 87, 250, 85),
              Color.fromARGB(255, 99, 249, 97),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: const Text(
          'Roulette Lite',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 0, 0, 0),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _gameRouletteWheel() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage("assets/runderrandaussen.png"),
          ),
        ),
        child: InkWell(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.rotate(
              angle: animationController.value * bogenmass,
              child: Container(
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/rouletterad.png"),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gameStatistic() {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 1.0 / 3.0,
        child: Container(
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 107, 255, 105),
                Color.fromARGB(255, 168, 255, 167)
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Table(
            border: TableBorder.all(color: Colors.black),
            children: [
              TableRow(
                children: [
                  _titleColumn("Number"),
                  _valueColumn(SelectedNumber),
                ],
              ),
              TableRow(
                children: [
                  _titleColumn("Color"),
                  _valueColumn(SelectedColor),
                ],
              ),
              TableRow(
                children: [
                  _titleColumn("Spins"),
                  _valueColumn(NumberRotations),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _titleColumn(String Title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            Title,
            style: const TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ],
    );
  }

  Column _valueColumn(var value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            '$value',
            style: const TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _coinDisplay() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 1.0 / 4.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 125, 251, 242),
                Color.fromARGB(255, 80, 211, 255),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Table(
            border: TableBorder.all(color: Colors.black),
            children: [
              TableRow(
                children: [
                  _titleColumn("Coins"),
                  _valueColumn(coins),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
