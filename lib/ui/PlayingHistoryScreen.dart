import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/GameStatementWidget.dart';
import 'package:kuber_starline/customs/history_type.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/game_list_response_data.dart';
import 'package:kuber_starline/network/models/game_list_response_model.dart';
import 'package:kuber_starline/network/models/jackpot_response_data.dart';
import 'package:kuber_starline/network/models/playing_history_response_data.dart';
import 'package:kuber_starline/network/models/playing_history_response_model.dart';
import 'package:kuber_starline/network/models/starline_response_data.dart';
import 'package:kuber_starline/network/models/winning_history_response_data.dart';
import 'package:kuber_starline/network/models/winning_history_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayingHistoryScreen extends StatefulWidget {
  final HistoryType historyType;
  final bool isJackPot;
  final bool isStarline;
  final List<JackpotResponseData> listOfJackpotGames;
  final List<StarlineResponseData> listOfStarlineGames;

  PlayingHistoryScreen(
      {@required this.historyType,
      @required this.isJackPot,
      @required this.isStarline,
      this.listOfJackpotGames,
      this.listOfStarlineGames});

  @override
  _PlayingHistoryScreenState createState() => _PlayingHistoryScreenState();
}

class _PlayingHistoryScreenState extends State<PlayingHistoryScreen> {
  HistoryType historyType;

  String authToken = "";

  String currentDate = "";
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime selectedDate = DateTime.now();
  String selectedDateAsString = "";

  List<GameListData> gameListData = List();
  GameListData selectedGame = GameListData();

  List<PlayingHistoryResponseData> playingHistoryData = List();
  List<WinningHistoryResponseData> winningHistoryData = List();

  List<JackpotResponseData> listOfJackpotGames = List();
  List<StarlineResponseData> listOfStarlineGames = List();

  bool _showProgress = false;
  bool _isJackpot = false;
  bool _isStarline = false;

  @override
  void initState() {
    super.initState();
    historyType = widget.historyType;
    _isJackpot = widget.isJackPot;
    _isStarline = widget.isStarline;
    listOfJackpotGames = widget.listOfJackpotGames;
    listOfStarlineGames = widget.listOfStarlineGames;

    fetchAuthToken();
    getCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            shadowColor: Colors.transparent,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              (historyType == HistoryType.Playing)
                  ? 'Playing History'
                  : 'Winning History',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            centerTitle: true,
            leading: InkWell(
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
                margin: EdgeInsets.fromLTRB(5, 80, 5, 0),
                padding: EdgeInsets.all(5),
                height: 130,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    (gameListData != null && gameListData.isNotEmpty)
                        ? Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  isExpanded: true,
                                  elevation: 5,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  value: selectedGame,
                                  items: gameListData
                                      .map(
                                        (element) => DropdownMenuItem(
                                          child: Center(
                                            child: Text(
                                              element.gamename,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          value: element,
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGame = value;
                                    });
                                  }),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          )
                        : Container(),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  selectedDateAsString == ""
                                      ? currentDate
                                      : selectedDateAsString,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                            width: 140,
                            alignment: Alignment.center,
                          ),
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now())
                                .then((newDate) => {updateDateWidget(newDate)});
                          },
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: ButtonTheme(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Search',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                if (selectedDateAsString != "") {
                                  setState(() {
                                    _showProgress = true;
                                    playingHistoryData.clear();
                                    winningHistoryData.clear();
                                  });

                                  if (historyType == HistoryType.Playing) {
                                    HTTPService()
                                        .fetchPlayingHistory(
                                            selectedGame.pkGameId.toString(),
                                            selectedDate,
                                            authToken)
                                        .then((response) =>
                                            {updateList(response)});
                                  } else if (historyType ==
                                      HistoryType.Winning) {
                                    HTTPService()
                                        .fetchWinningHistory(
                                            selectedGame.pkGameId.toString(),
                                            selectedDate,
                                            authToken)
                                        .then((response) =>
                                            {updateList(response)});
                                  }
                                }
                              },
                              elevation: 5,
                              color: Colors.red,
                              splashColor: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              ((historyType == HistoryType.Playing &&
                          playingHistoryData != null &&
                          playingHistoryData.isNotEmpty) ||
                      (historyType == HistoryType.Winning &&
                          winningHistoryData != null &&
                          winningHistoryData.isNotEmpty))
                  ? Container(
                      margin: EdgeInsets.fromLTRB(5, 220, 5, 0),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          itemBuilder: (context, index) {
                            if (historyType == HistoryType.Playing) {
                              PlayingHistoryResponseData historyData =
                                  playingHistoryData[index];

                              return Column(
                                children: [
                                  GameStatementWidget(
                                    marketName: selectedGame.gamename,
                                    gameName: historyData.gametype,
                                    particular: 'Game Play',
                                    debitOrCredit: 'Debit',
                                    gameType: historyData.gametype,
                                    playPoint: historyData.betamount,
                                    digitPlayed: historyData.betNo,
                                    playTime: historyData.gametime,
                                    playDate: selectedDateAsString,
                                    balance: '',
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              );
                            } else {
                              WinningHistoryResponseData historyData =
                                  winningHistoryData[index];

                              return Column(
                                children: [
                                  GameStatementWidget(
                                    marketName: selectedGame.gamename,
                                    gameName: historyData.gametype,
                                    particular: 'Game Play',
                                    debitOrCredit: 'Debit',
                                    gameType: historyData.gametype,
                                    playPoint: historyData.betamount,
                                    digitPlayed: historyData.betNo,
                                    playTime: historyData.gametime,
                                    playDate: selectedDateAsString,
                                    balance: historyData.balance,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              );
                            }
                          },
                          itemCount: playingHistoryData.length > 0
                              ? playingHistoryData.length
                              : winningHistoryData.length))
                  : !_showProgress
                      ? Align(
                          alignment: Alignment.center,
                          child: Text(
                            historyType == HistoryType.Playing
                                ? 'No games played yet!'
                                : 'No games won yet!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
            ],
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();

    return true;
  }

  void fetchAuthToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);

    if (!_isJackpot && !_isStarline) {
      HTTPService().fetchGameList(authToken).then((response) => {
            if (response.statusCode == 200)
              {updateGameList(response)}
            else
              {showErrorDialog(context, 'Failed to fetch games')}
          });
    } else {
      if (_isJackpot) {
        for (int i = 0; i < listOfJackpotGames.length; i++) {
          GameListData gameName = GameListData(
              pkGameId: listOfJackpotGames[i].pkUserCreation,
              gamename: listOfJackpotGames[i].gamename);

          gameListData.add(gameName);
        }

        setState(() {
          selectedGame = gameListData[0];
        });
      } else if (_isStarline) {
        for (int i = 0; i < listOfStarlineGames.length; i++) {
          GameListData gameName = GameListData(
              pkGameId: listOfStarlineGames[i].pkUserCreation,
              gamename: listOfStarlineGames[i].gamename);

          gameListData.add(gameName);
        }

        setState(() {
          selectedGame = gameListData[0];
        });
      }
    }
  }

  updateGameList(Response response) {
    GameListResponseModel gameListResponseModel =
        GameListResponseModel.fromJson(json.decode(response.body));

    if (gameListResponseModel.status) {
      List<GameListData> normalGameList = List();
      List<GameListData> jackpotGameList = List();
      List<GameListData> starlineGameList = List();

      for (int i = 0; i < gameListResponseModel.data.length; i++) {
        GameListData data = gameListResponseModel.data[i];
        if (data.typeOfGame == '1') {
          normalGameList.add(data);
        } else if (data.typeOfGame == '2') {
          starlineGameList.add(data);
        } else {
          jackpotGameList.add(data);
        }
      }

      gameListData.addAll(normalGameList);
      gameListData.addAll(starlineGameList);
      gameListData.addAll(jackpotGameList);

      setState(() {
        selectedGame = gameListData[0];
      });
    } else {
      showErrorDialog(context, gameListResponseModel.message);
    }
  }

  void showErrorDialog(BuildContext buildContext, String message) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return CustomAlertDialog(
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            content: Container(
              width: 60,
              height: 170,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: InkWell(
                        child: RaisedButton(
                          color: Colors.red,
                          splashColor: Colors.white,
                          child: Text(
                            'Close',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void getCurrentDate() {
    DateTime dateTime = DateTime.now();

    setState(() {
      currentDate = dateFormat.format(dateTime);
      selectedDateAsString = DateFormat('dd-MM-yyyy').format(dateTime);
    });
  }

  updateDateWidget(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      selectedDateAsString = DateFormat('dd-MM-yyyy').format(newDate);
    });
  }

  updateList(Response response) {
    if (historyType == HistoryType.Playing) {
      if (response.statusCode == 200) {
        PlayingHistoryResponseModel responseModel =
            PlayingHistoryResponseModel.fromJson(json.decode(response.body));

        if (responseModel.status) {
          setState(() {
            _showProgress = false;
            playingHistoryData = responseModel.data;
          });
        } else {
          setState(() {
            _showProgress = false;
          });
        }
      } else {
        setState(() {
          _showProgress = false;
        });
      }
    } else if (historyType == HistoryType.Winning) {
      if (response.statusCode == 200) {
        WinningHistoryResponseModel responseModel =
            WinningHistoryResponseModel.fromJson(json.decode(response.body));

        if (responseModel.status) {
          setState(() {
            _showProgress = false;
            winningHistoryData = responseModel.data;
          });
        } else {
          setState(() {
            _showProgress = false;
          });
        }
      } else {
        setState(() {
          _showProgress = false;
        });
      }
    }
  }
}
