import 'package:flutter/material.dart';
import 'package:kuber_starline/constants/game_type_constants.dart';
import 'package:kuber_starline/customs/game_chip.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/customs/utility_methods.dart';
import 'package:kuber_starline/network/models/game_model.dart';
import 'package:kuber_starline/ui/DashboardScreen.dart';
import 'package:kuber_starline/ui/FullSangamGameScreen.dart';
import 'package:kuber_starline/ui/GameScreen.dart';
import 'package:kuber_starline/ui/HalfSangamGameScreen.dart';

class GameDashboard extends StatefulWidget {
  final GameData gameData;
  final bool isJackpot;
  final String selectedJackpotTime;
  final bool isStarline;

  GameDashboard(
      {this.gameData,
      @required this.isJackpot,
      @required this.isStarline,
      @required this.selectedJackpotTime});

  @override
  _GameDashboardState createState() => _GameDashboardState();
}

class _GameDashboardState extends State<GameDashboard> {
  GameData gameData;
  bool _isJackpot = false;
  bool _isStarline = false;
  String selectedJackpotTime = "";

  @override
  void initState() {
    super.initState();
    gameData = widget.gameData;
    _isJackpot = widget.isJackpot;
    _isStarline = widget.isStarline;
    selectedJackpotTime = widget.selectedJackpotTime;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: new DecorationImage(
                    image: AssetImage(
                      'images/casino_bg.jpg',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(12, 40, 0, 0),
                child: InkWell(
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onTap: () {
                    onBackPressed();
                  },
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text(
                    gameData.gamename,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              _isJackpot ? buildJackpotDisplay() : buildDislayTypeOne(),
            ],
          ),
        ),
        onWillPop: onBackPressed);
  }

  Widget buildDislayTypeOne() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Container(
              child: GameChip(
                gameName: 'Single\nDigits',
                color: Colors.pink,
                assetString: 'images/ic_single_digit.png',
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GameScreen(
                        gameData: gameData,
                        gameType: 'Single Digits',
                        gameConstant: GameTypeConstants.Single_DIGITS,
                        isJackpot: _isJackpot,
                        isStarline: _isStarline,
                        selectedJackpotTime: selectedJackpotTime,
                      )));
            },
          ),
          SizedBox(
            height: 10,
          ),
          UtilityMethodsManager().findDifference(gameData.slot2Time1)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    !_isStarline && !_isJackpot
                        ? InkWell(
                            child: Container(
                              child: GameChip(
                                gameName: 'Half\nSangam',
                                color: Colors.blue,
                                assetString: 'images/ic_half_sangam.png',
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(ScaleRoute(
                                  page: HalfSangamGameScreen(
                                gameData: gameData,
                                gameType: 'Half Sangam',
                                gameConstant: GameTypeConstants.HALF_SANGAM,
                                bettingOpenTime: gameData.slot2Time1,
                                bettingCloseTime: gameData.slot2Time2,
                              )));
                            },
                          )
                        : Container(),
                    !_isStarline && !_isJackpot
                        ? InkWell(
                            child: Container(
                              child: GameChip(
                                gameName: 'Full\nSangam',
                                color: Colors.blue,
                                assetString: 'images/ic_full_sangam.png',
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(ScaleRoute(
                                  page: FullSangamGameScreen(
                                gameData: gameData,
                                gameType: 'Full Sangam',
                                gameConstant: GameTypeConstants.FULL_SANGAM,
                                bettingTime: gameData.slot2Time1,
                              )));
                            },
                          )
                        : Container(),
                  ],
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          !_isStarline && !_isJackpot
              ? UtilityMethodsManager().findDifference(gameData.slot2Time1)
                  ? InkWell(
                      child: Container(
                        child: GameChip(
                          gameName: 'Jodi\nDigit',
                          color: Colors.blue,
                          assetString: 'images/ic_jodi.png',
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GameScreen(
                                  gameData: gameData,
                                  gameType: 'Jodi Digit',
                                  gameConstant: GameTypeConstants.JODI_DIGIT,
                                  isJackpot: _isJackpot,
                                  isStarline: _isStarline,
                                  selectedJackpotTime: gameData.slot2Time1,
                                )));
                      },
                    )
                  : Container()
              : Container(),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 10,
              ),
              InkWell(
                child: Container(
                  child: GameChip(
                    gameName: 'Single\nPanna',
                    color: Colors.red,
                    assetString: 'images/ic_single_panna.png',
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GameScreen(
                            gameData: gameData,
                            gameType: 'Single Panna',
                            gameConstant: GameTypeConstants.Single_PANNA,
                            isJackpot: _isJackpot,
                            isStarline: _isStarline,
                            selectedJackpotTime: selectedJackpotTime,
                          )));
                },
              ),
              SizedBox(
                width: 40,
              ),
              InkWell(
                child: Container(
                  child: GameChip(
                    gameName: 'Double\nPanna',
                    color: Colors.red,
                    assetString: 'images/ic_double_panna.png',
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GameScreen(
                            gameData: gameData,
                            gameType: 'Double Panna',
                            gameConstant: GameTypeConstants.Double_PANNA,
                            isJackpot: _isJackpot,
                            isStarline: _isStarline,
                            selectedJackpotTime: selectedJackpotTime,
                          )));
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            child: Container(
              child: GameChip(
                gameName: 'Triple\nPanna',
                color: Colors.blue,
                assetString: 'images/ic_triple_panna.png',
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GameScreen(
                        gameData: gameData,
                        gameType: 'Triple Panna',
                        gameConstant: GameTypeConstants.Triple_PANNA,
                        isJackpot: _isJackpot,
                        isStarline: _isStarline,
                        selectedJackpotTime: selectedJackpotTime,
                      )));
            },
          ),
        ],
      ),
    );
  }

  Future<bool> onBackPressed() async {
    if (!_isJackpot && !_isStarline) {
      Navigator.of(context).pushAndRemoveUntil(
          ScaleRoute(page: DashboardScreen()), (route) => false);
    } else {
      Navigator.of(context).pop();
    }
    return true;
  }

  Widget buildJackpotDisplay() {
    return Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 80),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'JACKPOT GAMES',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: GameChip(
                      gameName: 'Left\nDigit',
                      color: Colors.red,
                      assetString: 'images/ic_left_digit.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GameScreen(
                              gameData: gameData,
                              gameType: 'Left Digit',
                              gameConstant: GameTypeConstants.LEFT_DIGIT,
                              isJackpot: _isJackpot,
                              isStarline: _isStarline,
                              selectedJackpotTime: selectedJackpotTime,
                            )));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: GameChip(
                      gameName: 'Jodi\nDigit',
                      color: Colors.blue,
                      assetString: 'images/ic_jodi.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GameScreen(
                              gameData: gameData,
                              gameType: 'Jodi Digit',
                              gameConstant: GameTypeConstants.JODI_DIGIT,
                              isJackpot: _isJackpot,
                              isStarline: _isStarline,
                              selectedJackpotTime: gameData.slot2Time1,
                            )));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: GameChip(
                      gameName: 'Right\nDigit',
                      color: Colors.red,
                      assetString: 'images/ic_right_digit.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GameScreen(
                              gameData: gameData,
                              gameType: 'Right Digit',
                              gameConstant: GameTypeConstants.RIGHT_DIGIT,
                              isJackpot: _isJackpot,
                              isStarline: _isStarline,
                              selectedJackpotTime: selectedJackpotTime,
                            )));
                  },
                ),
              ],
            )
          ],
        ));
  }
}
