import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/history_type.dart';
import 'package:kuber_starline/customs/marquee_text.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/customs/utility_methods.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/game_model.dart';
import 'package:kuber_starline/network/models/game_rate_response_data.dart';
import 'package:kuber_starline/network/models/game_rate_response_model.dart';
import 'package:kuber_starline/network/models/starline_response_data.dart';
import 'package:kuber_starline/network/models/starline_response_model.dart';
import 'package:kuber_starline/ui/DashboardScreen.dart';
import 'package:kuber_starline/ui/GameDashboard.dart';
import 'package:kuber_starline/ui/PlayingHistoryScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StarlineGameScreen extends StatefulWidget {
  @override
  _StarlineGameScreenState createState() => _StarlineGameScreenState();
}

class _StarlineGameScreenState extends State<StarlineGameScreen> {
  String walletBalance = "";
  String authToken = "";

  bool _showProgress = false;
  List<StarlineResponseData> starlineResponseData = List();
  List<GameRateResponseData> listOfGameRates = List();
  String todayDay = "";
  String todayDate = "";
  DateTime dateToday;
  String starlineName = "";

  @override
  void initState() {
    super.initState();

    getUserDetails();

    dateToday = DateTime.now();
    todayDay = DateFormat('EEE').format(dateToday);
    todayDate = DateFormat('dd-MM-yyyy').format(dateToday);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            shadowColor: Colors.transparent,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: MarqueeWidget(
              child: Text(
                'Starline',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
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
            actions: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    walletBalance.isNotEmpty
                        ? Text(
                            '\u{20B9}$walletBalance',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        : Text(
                            '\u{20B9}0',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ],
                ),
              ),
            ],
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
              _showProgress
                  ? Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.fromLTRB(5, 70, 5, 0),
                height: 150,
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    listOfGameRates != null && listOfGameRates.isNotEmpty
                        ? Container(
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(5),
                            child: buildListOfGameRates(),
                          )
                        : Container(),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Column(
                        children: [
                          InkWell(
                            child: Container(
                              width: 120,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Text(
                                'Bid History',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(ScaleRoute(
                                  page: PlayingHistoryScreen(
                                historyType: HistoryType.Playing,
                                isStarline: true,
                                isJackPot: false,
                                listOfStarlineGames: starlineResponseData,
                              )));
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            child: Container(
                              width: 120,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Text(
                                'Win History',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(ScaleRoute(
                                  page: PlayingHistoryScreen(
                                historyType: HistoryType.Winning,
                                isStarline: true,
                                isJackPot: false,
                                listOfStarlineGames: starlineResponseData,
                              )));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 220, 10, 0),
                width: MediaQuery.of(context).size.width,
                child: Material(
                  borderRadius: BorderRadius.circular(70),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/play_button.png',
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          starlineName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 12,
                  color: Colors.blue,
                ),
              ),
              starlineResponseData != null && starlineResponseData.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.fromLTRB(0, 280, 0, 0),
                      child: buildListOfGames(),
                    )
                  : Container(),
            ],
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pushAndRemoveUntil(
        ScaleRoute(page: DashboardScreen()), (route) => false);
    return true;
  }

  void getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);

    setState(() {
      walletBalance =
          sharedPreferences.getString(Constants.SHARED_PREF_WALLET_BALANCE);
      starlineName = sharedPreferences.getString(Constants.STARLINE_NAME);
    });

    fetchGameData();
  }

  void fetchGameData() {
    setState(() {
      _showProgress = true;
    });

    HTTPService().fetchStarlineGames(authToken).then((response) {
      setState(() {
        _showProgress = false;
      });
      if (response.statusCode == 200) {
        StarlineResponseModel responseModel =
            StarlineResponseModel.fromJson(json.decode(response.body));

        setState(() {
          starlineResponseData = responseModel.data;
        });
      } else {
        showErrorDialog('Could not fetch data!');
      }
    });

    HTTPService().fetchStarlineRate(authToken).then((response) {
      if (response.statusCode == 200) {
        GameRateResponseModel gameRateResponseModel =
            GameRateResponseModel.fromJson(json.decode(response.body));
        setState(() {
          listOfGameRates = gameRateResponseModel.data;
        });
      } else {
        print('Game rates could not be fetched');
      }
    });
  }

  void showSuccessDialog(BuildContext buildContext, String message) {
    if (mounted) {
      showDialog(
          context: buildContext,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              content: Container(
                width: 80,
                height: 200,
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
                        child: Image.asset(
                          'images/ic_success.png',
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
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
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  void showErrorDialog(String message) {
    if (mounted) {
      showDialog(
          context: context,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              content: Container(
                width: 60,
                height: 180,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    Container(
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
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                  ],
                ),
              ),
            );
          });
    }
  }

  Widget buildListOfGames() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      itemBuilder: (context, index) {
        return InkWell(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        '${UtilityMethodsManager().beautifyTime(starlineResponseData[index].slot2Time1)}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: displayMarketStatusWidget(
                          starlineResponseData[index].dayData,
                          starlineResponseData[index].holidayData,
                          starlineResponseData[index]),
                    ),
                  ],
                )),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          starlineResponseData[index].gamename,
                          style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text(
                          starlineResponseData[index].result1.substring(0, 3) +
                              "-" +
                              starlineResponseData[index]
                                  .result1
                                  .substring(3, 4),
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  shape: CircleBorder(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'images/play_button.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                  elevation: 5,
                ),
              ],
            ),
          ),
          onTap: () {
            checkMarketStatus(starlineResponseData[index]);
          },
        );
      },
      itemCount: starlineResponseData.length,
      shrinkWrap: true,
    );
  }

  Widget displayMarketStatusWidget(List<String> dayData,
      List<String> holidayData, StarlineResponseData gameData) {
    if (UtilityMethodsManager().findDifference(gameData.slot2Time1)) {
      if (dayData.isNotEmpty && dayData.contains(todayDay)) {
        if (holidayData.isEmpty || !holidayData.contains(todayDate)) {
          return Container(
            child: Text(
              'Market is open today',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return Container(
            child: Text(
              'Market is closed today',
              style: TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          );
        }
      } else {
        return Container(
          child: Text(
            'Market is closed today',
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        );
      }
    } else {
      return Container(
        child: Text(
          'Market is closed today',
          style: TextStyle(
              color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  void checkMarketStatus(StarlineResponseData starLineData) {
    if ((UtilityMethodsManager().findDifference(starLineData.slot2Time1)) &&
        starLineData.dayData.isNotEmpty &&
        starLineData.dayData.contains(todayDay)) {
      if (starLineData.holidayData.isEmpty ||
          !starLineData.holidayData.contains(todayDate)) {
        GameData gameData = GameData(
            gamename: starLineData.gamename,
            timeSlots: starLineData.timeSlots,
            slot2Time1: starLineData.slot2Time1,
            slot2Time2: "",
            result1: starLineData.result1,
            result2: "",
            pkUserCreation: starLineData.pkUserCreation,
            minData: starLineData.minData,
            holidayData: starLineData.holidayData,
            dayData: starLineData.dayData);

        Navigator.of(context).push(ScaleRoute(
            page: GameDashboard(
          gameData: gameData,
          selectedJackpotTime: starLineData.slot2Time1,
          isJackpot: false,
          isStarline: true,
        )));
      } else {
        showErrorDialog('Sorry! Market closed for the day');
      }
    } else {
      showErrorDialog('Sorry! Market closed for the day');
    }
  }

  Widget buildListOfGameRates() {
    return ListView.builder(
      padding: EdgeInsets.all(2),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: Row(
            children: [
              Container(
                width: 90,
                child: Text(
                  listOfGameRates[index].gametype == null
                      ? ""
                      : listOfGameRates[index].gametype,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(' 10 ka ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Container(
                width: 50,
                child: Text(
                  listOfGameRates[index].bhouAmt,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: listOfGameRates.length,
    );
  }
}
