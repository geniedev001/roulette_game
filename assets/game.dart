import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:math' as math;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  //Audioplayer
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  //Daten - Data
  List<int> sektoren = [
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
  List<String> farbsektoren = [
    'Grün', // Sektor 0 (Grün)
    'Rot', // Sektor 32 (Rot) - Sector 32 (Red)
    'Schwarz', // Sektor 15 (Schwarz) - Sector 15 (Black)
    'Rot', // Sektor 19 (Rot) -  Sector 19 (Red)
    'Schwarz', // Sektor 4 (Schwarz) - Sector 4 (Black)
    'Rot', // Sektor 21 (Rot) - Sector 21 (Red)
    'Schwarz', // Sektor 2 (Schwarz) - Sector 2 (Black)
    'Rot', // Sektor 25 (Rot)  - Sector 25 (Red)
    'Schwarz', // Sektor 17 (Schwarz) - Sector 17 (Black)
    'Rot', // Sektor 34 (Rot) - Sector 34 (Red)
    'Schwarz', // Sektor 6 (Schwarz) - Sector 6 (Black)
    'Rot', // Sektor 27 (Rot) - Sector 27 (Red)
    'Schwarz', // Sektor 13 (Schwarz) - Sector 13 (Black)
    'Rot', // Sektor 36 (Rot) - Sector 36 (Red)
    'Schwarz', // Sektor 11 (Schwarz) - Sector 11 (Black)
    'Rot', // Sektor 30 (Rot) - Sector 30 (Red)
    'Schwarz', // Sektor 8 (Schwarz) - Sector 8 (Black)
    'Rot', // Sektor 23 (Rot) - Sector 23 (Red)
    'Schwarz', // Sektor 10 (Schwarz) - Sector 10 (Black)
    'Rot', // Sektor 5 (Rot) - Sector 5 (Red)
    'Schwarz', // Sektor 24 (Schwarz) - Sector 24 (Black)
    'Rot', // Sektor 16 (Rot) - Sector 16 (Red)
    'Schwarz', // Sektor 33 (Schwarz) - Sector 33 (Black)
    'Rot', // Sektor 1 (Rot) - Sector 1 (Red)
    'Schwarz', // Sektor 20 (Schwarz) - Sector 20 (Black)
    'Rot', // Sektor 14 (Rot) - Sector 14 (Red)
    'Schwarz', // Sektor 31 (Schwarz) - Sector 31 (Black)
    'Rot', // Sektor 9 (Rot) - Sector 19 (Red)
    'Schwarz', // Sektor 22 (Schwarz) - Sector 22 (Black)
    'Rot', // Sektor 18 (Rot) - Sector 32 (Red)
    'Schwarz', // Sektor 29 (Schwarz) - Sector 29 (Black)
    'Rot', // Sektor 7 (Rot) - Sector 7 (Red)
    'Schwarz', // Sektor 28 (Schwarz) - Sector 28 (Black)
    'Rot', // Sektor 12 (Rot) - Sector 12 (Red)
    'Schwarz', // Sektor 35 (Schwarz) - Sector 35 (Black)
    'Rot', // Sektor 3 (Rot) - Sector 3 (Red)
    'Schwarz'
  ]; // Sektor 26 (Schwarz) - Sector 26 (Black)
  int randomSektorenIndex = -1; //alle -, randomSectorIndex
  List<double> sektorenWinkel = []; // sectorsAngle
  double bogenmass = 0; //pro sektorenWinkel - per sector angle

  //Flag zeigt an, ob sich Roulette dreht - Flag indicates whether roulette is spinning
  bool drehtsich = false; // drehtsich - turns

  //aktuell ausgewählte Zahl - currently selected number
  int ausgewaehlteZahl = 0; //selected number

  //Ausgewählte Farbe - Selected color
  String ausgewaehlteFarbe = "Grün"; //selectedcolor = "green"

  //Anzahl Drehungen - Number of spins
  int anzahlDrehungen = 0;

  //Zufallszahl - random number
  math.Random random = math.Random();

  //Spin Animation Controller
  late AnimationController animController;

  //Animation
  late Animation<double> animation;

  //Wetteinsätze - Betting stakes
  TextEditingController wetteinsatzController = TextEditingController(
      text: '200'); //wetteinsatzController - bet controller
  String selectedWetteArt = 'Rot'; //-red
  List<Wetteinsatz> wetteinsatzListe = []; //<Bet stake> bet stakeList

  // Wettcoins - bet coins
  double coins = 5000;
  double gewinnOderVerlust = 0; //profit or loss

  //initiales setup - initial
  @override
  void initState() {
    super.initState();

    //Generiere Sektoren Auswahl - //Generate sector selection
    generateSektorenWinkel();

    //animations Kontrolle, 5Sekunden Drehdauer - Control, 5 second rotation time
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5100),
    );

    //über einen Bereich hinweg animieren - animate across an area
    Tween<double> tween = Tween<double>(begin: 0, end: 1);

    //Kurvenverhalten - Cornering behavior
    CurvedAnimation kurve = CurvedAnimation(
      //curve
      parent: animController,
      curve: Curves.decelerate,
    );

    //animation
    animation = tween.animate(kurve); //curve

    //aktualisieren des Bildschirms mit einem Listener - updating the screen with a listener
    animController.addListener(() {
      //nur wenn animation zuende ist - only when animation is over
      if (animController.isCompleted) {
        //neubauen - build new
        setState(() {
          //aufnehmen der Statistik - recording the statistics
          recordStats();
          //update status bool
          drehtsich = false;
          wettenAbgleichen(); // rotates = false; betMatch();
        });
      }
    });
  }

  //Funktion für Sound abspielen - Play sound function
  Future<void> playSound(String assetPath) async {
    try {
      final Audio audio = Audio(assetPath);
      await audioPlayer.open(audio);
      audioPlayer.play();
    } catch (e) {
      print(
          'Fehler beim Abspielen der Audiodatei: $e'); //Error playing audio file
    }
  }

  //dispose controller nach dem Verwenden - dispose controller after using
  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    animController.dispose();
  }

  //Build Methode
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  //funktion zum Drehen des Roulettes - function for spinning the roulette
  void drehen() {
    // drehen - turn
    //wähle zufälligen Sektor - choose random sector
    randomSektorenIndex = random.nextInt(sektoren.length); //sektoren - sector
    double randomBogenmass =
        generateRandomSektorenWinkel(); //Bogenmass = generateRandomSektoren - Radians = generateRandomSectors
    animController.reset();
    bogenmass = randomBogenmass; //Bogenmass - radians
    animController.forward();
  }

  //Berechnung des nächsten Sektors - Calculation of the next sector
  double generateRandomSektorenWinkel() {
    //SectorsAngle
    return (2 * math.pi * sektoren.length) +
        sektorenWinkel[randomSektorenIndex]; //sector, SectorsAngle
  }

  // Diese Funktion generiert die Winkel für jeden Sektor. - This function generates the angles for each sector.
  void generateSektorenWinkel() {
    //Bogenmaß für einen Sektor - Radian measure for a sector
    double sektorBogenmass = 2 * math.pi / sektoren.length; //sectorRadians

    for (int i = 0; i < sektoren.length; i++) {
      sektorenWinkel
          .add((i + 1) * sektorBogenmass); //sectorAngle, sectorRadians
    }
  }

  //Spielstatistik aufzeichnen - Record game statistics
  void recordStats() {
    ausgewaehlteZahl = sektoren[sektoren.length - (randomSektorenIndex + 1)];
    ausgewaehlteFarbe =
        farbsektoren[sektoren.length - (randomSektorenIndex + 1)];
    anzahlDrehungen = anzahlDrehungen + 1;
  } //selectedNumber = sectors[sectors.length - (randomSectorsIndex + 1)];
  // selectedColor = colorsectors[sectors.length - (randomSectorsIndex + 1)];
  //numberRotations = numberRotations + 1;

  // Diese Funktion vergleicht die Wetten und berechnet den Gewinn oder Verlust
  //This function compares the bets and calculates the win or loss
  void wettenAbgleichen() {
    //betMatch
    gewinnOderVerlust = 0; //profitOrLost

    // Zerlege das gewonnene Ergebnis in Farbe und Zahl - Break down the resulting result into color and number
    final String gewonneneFarbe =
        ausgewaehlteFarbe; //color won = color selected
    final int gewonneneZahl = ausgewaehlteZahl;

    // Überprüfe, welche Wetten auf das gewonnene Ergebnis zutreffen - Check which bets apply to the won result
    for (final wetteinsatz in wetteinsatzListe) {
      // wetteinsatz-bet,wetteinsatzListe-betList
      if (wetteinsatz.art == gewonneneFarbe || //bet, color won
          (wetteinsatz.art == "Gerade" &&
              gewonneneZahl % 2 == 0) || //bet - Straigth - number won
          (wetteinsatz.art == "Ungerade" && gewonneneZahl % 2 != 0)) {
        // bet - odd - number won
        gewinnOderVerlust += (wetteinsatz.bet * 2)
            .toInt(); // Aktualisiere die Variable für den Gewinn oder Verlust - Update the profit or loss variable
        coins += (wetteinsatz.bet * 2)
            .toInt(); // Die Wette trifft zu, erhöhe die Coins um den Wetteinsatz verdoppelt - The bet is true, increase the coins by doubling the bet
      }
    }

    // Leere die Wettliste - Empty the betting list
    wetteinsatzListe.clear(); // bet list

    // Aktualisiere das Widget, um die neuen Coins und die geleerte Wettliste anzuzeigen
    setState(() {});

    //Rufe nächste Funktion auf - Call next function
    _zeigeGewinnOderVerlustPopup(
        gewinnOderVerlust); //_showWinOrLossPopup(winOrloss)
  }

  // Diese Funktion zeigt ein Popup mit Gewinn oder Verlust an - This feature displays a popup with profit or loss
  void _zeigeGewinnOderVerlustPopup(double gewinnOderVerlust) {
    //_showWinOrLossPopup(double winOrLoss)
    String nachricht; //news
    String titel = ""; //title
    if (gewinnOderVerlust > 0) {
      //winOrLoss
      playSound("assets/cashSound.mp3");
      nachricht = "Du hast gewonnen."; //news - You won!
      titel = "SIEG"; // title - VICTORY
    } else {
      playSound("assets/bruhSound.mp3");
      nachricht = "Du hast keine Coins gewonnen."; //You didn't win any coins.
      titel = "Kein Gewinn"; //No profit
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titel),
          content: Text(nachricht),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Schließe das Popup -Close the popup
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Diese Funktion setzt das Spiel zurück - This function resets the game
  void resetSpiel() {
    //resetGame
    drehtsich = false; //turns
    bogenmass = 0; //radians
    ausgewaehlteZahl = 0; //selected number
    ausgewaehlteFarbe = "Grün"; //selected color
    anzahlDrehungen = 0; //number of rotations
    coins = 5000;
    wetteinsatzListe.clear(); //bet list
    setState(() {});
    animController.reset();
  }

  // Diese Funktion behandelt das Platzieren von Wetten und aktualisiert den Spielzustand -This feature handles placing bets and updating the game state
  void handleWetteUndSpiel(double wetteinsatz, String wetteArt) {
    //bet
    // Überprüfe, ob der Wetteinsatz gültig ist und ob der Spieler genügend Coins hat - // Check whether the bet is valid and whether the player has enough coins
    if (wetteinsatz <= 0 || wetteinsatz > coins) {
      //bet
      // Zeige eine Fehlermeldung oder Toast an, dass die Wette ungültig ist - Display an error message or toast that the bet is void
      return;
    }

    // Durchlaufe die vorhandenen Wetten und prüfe, ob die Wettart bereits existiert -Go through the existing bets and check whether the bet type already exists+
    bool wetteArtExists = false; //bet
    for (int i = 0; i < wetteinsatzListe.length; i++) {
      //betList
      final Wetteinsatz wetteinsatzObj =
          wetteinsatzListe[i]; //Bet betObj = betList
      if (wetteinsatzObj.art == wetteArt) {
        //betObj.art == betType
        // Die Wettart existiert bereits, erhöhe den Betrag dazu - The bet type already exists, increase the amount
        wetteinsatzListe[i].bet += wetteinsatz; //betList - bet
        wetteArtExists = true; //bet
        break; // Wir haben die Wette gefunden, daher können wir die Schleife verlassen - We found the bet, so we can exit the loop
      }
    }

    if (!wetteArtExists) {
      //bet
      // Die Wettart wurde nicht gefunden, füge sie zur Liste hinzu - The bet type was not found, add it to the list
      wetteinsatzListe.add(Wetteinsatz(bet: wetteinsatz, art: wetteArt));
    } //bet_stakeList.add(bet_stake(bet: bet_stake, type: betType));

    // Reduziere die Coins um den Wetteinsatz -Reduce the coins by the bet amount
    coins -= wetteinsatz; //bet

    // Aktualisiere das Widget, um die neue Wettliste anzuzeigen - Refresh the widget to show the new betting list
    setState(() {});
  }

  //Hauptwidget - Main widget
  Widget _body() {
    //hintergrund und spiel - background and game
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
      //Enthält den Inhalt des Spiels - Contains the content of the game
      child: _spielContent(), //spiel - game
    );
  }

  //Alle Widget-Inhalte aufgelistet - All widget content listed
  Widget _spielContent() {
    //game
    //verwende Stack - use stack
    return Stack(
      children: [
        _spielTitel(), //_gameTitle(),
        _spielRouletteRad(), //_gameRouletteWheel(),
        _spielAktionDrehen(), //_gameActionRotate(),
        _spielAktionenReset(), //_gameActionsReset(),
        _spielStatistik(), //_gameStatistics(),
        _spielWetteinsatz(), //_playBetStake(),
        _coinsAnzeige(), // _coinsDisplay(),
      ],
    );
  }

  //Widget für den Titel des Spiels - Game title widget
  Widget _spielTitel() {
    //gameTitle
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
                  Color.fromARGB(255, 99, 249, 97)
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: const Text("Roulette Lite",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontStyle: FontStyle.italic,
                ))));
  }

  //Dieses Widget erstellt das Roulette-Rad und seine Animation. - This widget creates the roulette wheel and its animation.
  Widget _spielRouletteRad() {
    //gameRouletteWheel
    return Center(
      child: Container(
        //Hier drin ist der äußere Rand mit transparenter Mitte - In here is the outer edge with a transparent middle
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage("assets/runderrandaussen.png"),
          ),
        ),

        //animierter Builder für das Drehen - nized builder for turning
        child: InkWell(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.rotate(
                  angle: animController.value * bogenmass,
                  child: Container(
                    margin: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.005),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(
                          "assets/rouletterad.png"), //kreisrundes Bild - circular image
                    )),
                  ));
            },
          ),
        ),
      ),
    );
  }

  // Dieses Widget zeigt die Spielstatistik an. - This widget displays game statistics.
  Widget _spielStatistik() {
    //gameStatistic
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 1.0 /
            3.0, // Ein Drittel des verfügbaren Platzes - A third of the available space
        child: Container(
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: CupertinoColors.black,
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
            border: TableBorder.all(color: CupertinoColors.black),
            children: [
              TableRow(
                children: [
                  _titelSpalte("Zahl"), //titleColumn - Number
                  _wertSpalte(ausgewaehlteZahl), //_valueColumn(selectedNumber)
                ],
              ),
              TableRow(
                children: [
                  _titelSpalte("Farbe"), //titleColumn - color
                  _wertSpalte(ausgewaehlteFarbe), //_valueColumn(selectedcolor)
                ],
              ),
              TableRow(
                children: [
                  _titelSpalte("Spins"), //titleColumn
                  _wertSpalte(anzahlDrehungen), //_valueColumn(numberRotations),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dieses Widget erstellt eine Spalte für Titel. - This widget creates a column for titles.
  Column _titelSpalte(String titel) {
    //titleColumn - title
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(titel,
                style: const TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 0, 0, 0),
                ))),
      ],
    );
  }

  // Dieses Widget erstellt eine Spalte für Werte. - This widget creates a column for values.
  Column _wertSpalte(var wert) {
    //_valueColumn(var value)
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text('$wert', //$worth
                style: const TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 0, 0, 0),
                ))),
      ],
    );
  }

  // Dieses Widget erstellt eine Spalte für Werte. -This widget creates a column for values.
  Widget _coinsAnzeige() {
    //_coinsDisplay
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 1.0 / 4.0, // Weitenverhältnis - width ratio
        child: Container(
          margin: const EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: CupertinoColors.black,
              width: 2,
            ),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 125, 251, 242),
                Color.fromARGB(255, 80, 211, 255)
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          //Tabelle - table
          child: Table(
            border: TableBorder.all(color: CupertinoColors.black),
            children: [
              TableRow(
                children: [
                  _titelSpalte("Coins"),
                  _wertSpalte(coins),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dieses Widget zeigt den Button "Drehen" an - This widget displays the "Rotate" button
  Widget _spielAktionDrehen() {
    //_gameActionRotate
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
                //Drehen Knopf - Rotate button
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        // Ändere die Hintergrundfarbe basierend auf dem drehtsich-Status - Change the background color based on the spinning status
                        color: drehtsich //turns
                            ? Colors.transparent
                            : const Color.fromARGB(
                                255, 255, 17, 0), //drehtsich - rotates
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      child: Text(
                        drehtsich
                            ? "Dreht sich"
                            : "Drehen", //turns? "Turns": "Rotate",
                        style: TextStyle(
                          fontSize: drehtsich ? 10 : 25,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      )),
                  onTap: () {
                    setState(() {
                      if (!drehtsich) {
                        //sound abspielen - play
                        playSound("assets/roulette_sound1.mp3");
                        drehen();
                        drehtsich = true;
                      }
                    });
                  },
                )
              ],
            )));
  }

  // Dieses Widget zeigt den Button "Reset" an - This widget displays the “Reset” button
  Widget _spielAktionenReset() {
    //_gameActionsReset
    return Align(
        alignment: Alignment.topRight,
        child: Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              left: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Reset Knopf //Reset button
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        // Ändere die Hintergrundfarbe basierend auf dem drehtsich-Status - Change the background color based on the spinning status
                        color: const Color.fromARGB(255, 255, 252, 252),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(201, 0, 0, 0),
                        ),
                      )),
                  onTap: () {
                    if (drehtsich) return;
                    setState(() {
                      playSound("assets/buttonSound.mp3");
                      resetSpiel();
                    });
                  },
                ),
              ],
            )));
  }

  // Dieses Widget zeigt den Wetteinsatz und ermöglicht das Platzieren von Wetten - This widget shows the betting stake and allows you to place bets
  Widget _spielWetteinsatz() {
    //_play bet
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
          padding: const EdgeInsets.all(
              10.0), // Allgemeiner Innenabstand für das gesamte Widget - General padding for the entire widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Eingabefeld für Coins - Input field for coins
              TextFormField(
                controller: wetteinsatzController, //bet controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                  labelText: 'Wetteinsatz', //'Bet'
                  labelStyle: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),

              const SizedBox(height: 10),

              //Dropdownbutton zum Auswählen der Wettart //Dropdown button to select the bet type
              Container(
                width: screenWidth * (1.0 / 3.3),
                height: screenHeight * (1.0 / 7.5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 130, 255, 105),
                  borderRadius: BorderRadius.circular(
                      8.0), // Füge gerundete Ecken hinzu //Add rounded corners
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      value: selectedWetteArt,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedWetteArt = newValue ?? 'Rot';
                        });
                      },
                      items: <String>[
                        'Rot', 'Schwarz', 'Gerade',
                        'Ungerade' //rot-red,Schwarz - black,Gerade - Straight,Ungerade-odd
                      ].map((String value) {
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

              //Bestätigen Knopf - Confirm button
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    playSound("assets/buttonSound.mp3");
                    double wetteinsatz = //bet
                        double.tryParse(wetteinsatzController.text) ?? 0.0;
                    String wettenArt =
                        selectedWetteArt; // betArt = selectedBetteArt
                    handleWetteUndSpiel(wetteinsatz, wettenArt);
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: const Text(
                    'Bestätigen', //Bestätigen
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 5, 91, 4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //Liste aller Wetten der Runde - List of all bets of the round,
              const Text(
                'Wettliste:', //BettingList
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(
                      0.0), // Ändere den Radius nach Bedarf - Change the radius as needed
                ),
                height: 6 *
                    13.0, // Höhe für vier Zeilen mit einer Schriftgröße von 13 - Height for four lines with a font size of 13
                width: screenWidth *
                    0.3, // Breite auf 30 % der Bildschirmbreite festlegen - Set width to 30% of screen width
                child: Center(
                  child: Text(
                    wetteinsatzListe.isEmpty
                        ? 'Keine Wetten platziert' //No bets placed
                        : wetteinsatzListe
                            .map((wetteinsatz) =>
                                '${wetteinsatz.art}: ${wetteinsatz.bet.toStringAsFixed(2)}')
                            .join('\n'),
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                    maxLines:
                        5, // Maximal fünf Zeilen anzeigen - Display a maximum of five lines
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

// Eine einfache Datenklasse, um Wetten zu speichern - A simple data class to store bets
class Wetteinsatz {
  //Betting stake
  double bet;
  String art;

  Wetteinsatz({required this.bet, required this.art});
}
