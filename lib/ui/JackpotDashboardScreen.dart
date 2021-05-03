import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/history_type.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/customs/utility_methods.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/game_model.dart';
import 'package:kuber_starline/network/models/game_rate_response_data.dart';
import 'package:kuber_starline/network/models/game_rate_response_model.dart';
import 'package:kuber_starline/network/models/get_wallet_response_model.dart';
import 'package:kuber_starline/network/models/jackpot_response_data.dart';
import 'package:kuber_starline/network/models/jackpot_response_model.dart';
import 'package:kuber_starline/network/models/wallet_model.dart';
import 'package:kuber_starline/ui/DashboardScreen.dart';
import 'package:kuber_starline/ui/GameDashboard.dart';
import 'package:kuber_starline/ui/PlayingHistoryScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JackpotDashboardScreen extends StatefulWidget {
  @override
  _JackpotDashboardScreenState createState() => _JackpotDashboardScreenState();
}

class _JackpotDashboardScreenState extends State<JackpotDashboardScreen> {
  bool isOpenDrawer = false;
  String authToken = "";
  WalletData _walletData = WalletData();
  List<JackpotResponseData> listOfGames = List.empty(growable: true);
  List<GameRateResponseData> listOfGameRates = List.empty(growable: true);

  bool _showProgress = false;
  String todayDay = "";
  String todayDate = "";
  DateTime dateToday = DateTime.now();
  String jackpotName = "";

  @override
  void initState() {
    fetchAuthToken();
    super.initState();

    dateToday = DateTime.now();
    todayDay = DateFormat('EEE').format(dateToday);
    todayDate = DateFormat('dd-MM-yyyy').format(dateToday);

    SharedPreferences.getInstance().then((sharedPrefs) {
      setState(() {
        jackpotName = sharedPrefs.getString(Constants.JACKPOT_NAME);
      });
    });
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
              'Jackpot',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
                    (_walletData != null && _walletData.balance.isNotEmpty)
                        ? Text(
                            '\u{20B9}${_walletData.balance}',
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
                                isStarline: false,
                                isJackPot: true,
                                listOfJackpotGames: listOfGames,
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
                                isStarline: false,
                                isJackPot: true,
                                listOfJackpotGames: listOfGames,
                              )));
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 190, 10, 0),
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
                          jackpotName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 5,
                  color: Color(0xFFFFCCCB),
                ),
              ),
              listOfGames != null && listOfGames.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.fromLTRB(0, 250, 0, 0),
                      child: buildListOfGamesNew(),
                    )
                  : Container(),
            ],
          ),
        ),
        onWillPop: onBackPressed);
  }

  Widget buildListOfGamesNew() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            height: 80,
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        '${UtilityMethodsManager().beautifyTime(listOfGames[index].slot2Time1)}',
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
                          listOfGames[index].dayData,
                          listOfGames[index].holidayData,
                          listOfGames[index]),
                    ),
                  ],
                )),
                Container(
                  width: 150,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          listOfGames[index].gamename,
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text(
                          listOfGames[index].result1,
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
                      height: 40,
                      width: 40,
                    ),
                  ),
                  elevation: 5,
                ),
              ],
            ),
          ),
          onTap: () {
            checkMarketStatus(listOfGames[index]);
          },
        );
      },
      itemCount: listOfGames.length,
    );
  }

  void checkMarketStatus(JackpotResponseData jackpotResponseData) {
    if ((UtilityMethodsManager()
            .findDifference(jackpotResponseData.slot2Time1)) &&
        jackpotResponseData.dayData.isNotEmpty &&
        jackpotResponseData.dayData.contains(todayDay)) {
      if (jackpotResponseData.holidayData.isEmpty ||
          !jackpotResponseData.holidayData.contains(todayDate)) {
        GameData gameData = GameData(
            gamename: jackpotResponseData.gamename,
            dayData: jackpotResponseData.dayData,
            holidayData: jackpotResponseData.holidayData,
            minData: jackpotResponseData.minData,
            pkUserCreation: jackpotResponseData.pkUserCreation,
            result1: "",
            result2: "",
            slot2Time1: jackpotResponseData.slot2Time1,
            slot2Time2: jackpotResponseData.slot2Time2,
            timeSlots: jackpotResponseData.timeSlots);

        Navigator.of(context).push(ScaleRoute(
            page: GameDashboard(
                isJackpot: true,
                isStarline: false,
                gameData: gameData,
                selectedJackpotTime: jackpotResponseData.slot2Time1)));
      } else {
        showErrorDialog(context, 'Sorry! Market closed for the day');
      }
    } else {
      showErrorDialog(context, 'Sorry! Market closed for the day');
    }
  }

  Widget displayMarketStatusWidget(List<String> dayData,
      List<String> holidayData, JackpotResponseData gameData) {
    if (UtilityMethodsManager().findDifference(gameData.slot2Time1)) {
      if (dayData.isNotEmpty && dayData.contains(todayDay)) {
        if (holidayData.isEmpty || !holidayData.contains(todayDate)) {
          return Text(
            'Market is open today',
            style: TextStyle(
                color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
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

  void showErrorDialog(BuildContext buildContext, String message) {
    showDialog(
        context: buildContext,
        builder: (buildContext) {
          return CustomAlertDialog(
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            content: Container(
              width: 80,
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

  Future<bool> onBackPressed() async {
    Navigator.of(context).pushAndRemoveUntil(
        ScaleRoute(page: DashboardScreen()), (route) => false);
    return true;
  }

  void fetchAuthToken() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    authToken = sharedPrefs.getString(Constants.SHARED_PREF_AUTH_TOKEN);

    HTTPService().getWalletDetails(authToken).then((response) => {
          if (response.statusCode == 200)
            {showWalletData(response)}
          else
            {print('Wallet balance could not be fetched')}
        });

    HTTPService().fetchJackpotRate(authToken).then((response) {
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

    HTTPService().getJackpotGames(authToken).then((response) => {
          if (response.statusCode == 200)
            updateGameDetails(response)
          else
            print('Jackpot game details status code ${response.statusCode}')
        });
  }

  void showWalletData(Response response) async {
    var walletResponseJSON =
        GetWalletBalanceResponseModel.fromJson(json.decode(response.body));

    if (walletResponseJSON.status) {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setString(Constants.SHARED_PREF_WALLET_BALANCE,
          walletResponseJSON.data.balance);
      if (mounted) {
        setState(() {
          _walletData = walletResponseJSON.data;
        });
      }
    } else {
      print(response.body);
    }
  }

  void updateGameDetails(Response response) async {
    JackpotResponseModel responseModel =
        JackpotResponseModel.fromJson(json.decode(response.body));

    if (mounted) {
      if (responseModel.status) {
        setState(() {
          listOfGames = responseModel.data;
        });
      }
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
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
