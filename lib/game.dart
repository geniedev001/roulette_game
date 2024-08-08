import 'dart:core';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  List<int> sector = [
    0,
    32,
    15,
    19,
    4,
    21,
    2,
    25,
    17,
    34,
    6,
    27,
    13,
    36,
    11,
    30,
    8,
    23,
    10,
    5,
    24,
    16,
    33,
    1,
    20,
    14,
    31,
    9,
    22,
    18,
    29,
    7,
    28,
    12,
    35,
    3,
    26
  ];
  double Radians = 0;
  double coins = 5000;

  bool turns = false;

  late AnimationController animationController;

  late Animation<double> animation;

  String selectedColor = "green";

  int selectedNumber = 0;
  int numberRotations = 0;

  int randomSectorIndex = -1;
  List<double> sectorAngle = [];

  math.Random random = math.Random();

  TextEditingController betController = TextEditingController(text: '200');
  String selectedBetType = 'Red';
  List<Bet> betList = [];

  Future<void> playSound(String assetPath) async {
    try {
      final Audio audio = Audio(assetPath);
      await audioPlayer.open(audio);
      audioPlayer.play();
    } catch (e) {
      print('Error playing audio file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  void turn() {
    randomSectorIndex = random.nextInt(sector.length);
    double randomRadians = generateRandomSectorAngle();
    animationController.reset();
    Radians = randomRadians;
    animationController.forward();
  }

  double generateRandomSectorAngle() {
    return (2 * math.pi * sector.length) + sectorAngle[randomSectorIndex];
  }

  void resetGame() {
    turns = false;
    Radians = 0;
    selectedNumber = 0;
    selectedColor = "Green";
    numberRotations = 0;
    coins = 5000;
    betList.clear();
    setState(() {
      animationController.reset();
    });
  }

  void handleBetAndPlay(double bet, String betType) {
    if (bet <= 0 || bet > coins) {
      return;
    }
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
        _gameActionRotate(),
        _gameActionReset(),
        _gameStatistic(),
        _gameBet(),
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
              angle: animationController.value * Radians,
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
                  _valueColumn(selectedNumber),
                ],
              ),
              TableRow(
                children: [
                  _titleColumn("Color"),
                  _valueColumn(selectedColor),
                ],
              ),
              TableRow(
                children: [
                  _titleColumn("Spins"),
                  _valueColumn(numberRotations),
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

  Widget _gameActionRotate() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(
          top: 50,
          bottom: MediaQuery.of(context).size.height * 0.2,
          left: 20,
          right: MediaQuery.of(context).size.height * 0.2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  color: turns
                      ? Colors.transparent
                      : const Color.fromARGB(255, 255, 17, 0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: Text(
                  turns ? "Spinning" : "Turn",
                  style: TextStyle(
                    fontSize: turns ? 10 : 25,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  if (!turns) {
                    playSound("assets/roulette_sound1.mp3");
                    turn();
                    turns = true;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _gameActionReset() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.5,
          left: 20,
          right: 20,
        ),
        child: Row(
          children: [
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  color: const Color.fromARGB(255, 255, 252, 252),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: const Text(
                  "Reset",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(201, 0, 0, 0),
                  ),
                ),
              ),
              onTap: () {
                if (turns) return;
                setState(() {
                  playSound("assets/buttonSound.mp3");
                  resetGame();
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _gameBet() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: screenWidth * (1.0 / 3.3),
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 10,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 13, 100, 3),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: betController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                  labelText: 'Bet',
                  labelStyle: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: screenWidth * (1.0 / 3.3),
                height: screenHeight * (1.0 / 7.5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 130, 255, 105),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      value: selectedBetType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBetType = newValue ?? 'Red';
                        });
                      },
                      items: <String>['Red', 'Black', 'Even', 'Odd'].map(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    playSound("assets/buttonSound.mp3");
                    double bet = double.tryParse(betController.text) ?? 0.0;
                    String betType = selectedBetType;
                    handleBetAndPlay(bet, betType);
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 5, 91, 4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Bet {
  double bet;
  String art;

  Bet({required this.bet, required this.art});
}
