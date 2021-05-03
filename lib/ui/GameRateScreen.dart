import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/game_rate_response_data.dart';
import 'package:kuber_starline/network/models/game_rate_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameRateScreen extends StatefulWidget {
  @override
  _GameRateScreenState createState() => _GameRateScreenState();
}

class _GameRateScreenState extends State<GameRateScreen> {
  String authToken;
  List<GameRateResponseData> listOfMarketGameRates = List();
  List<GameRateResponseData> listOfStarlineGameRates = List();
  List<GameRateResponseData> listOfJackpotGameRates = List();

  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    fetchAuthToken();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
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
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 26,
                    ),
                    onTap: () {
                      onBackPressed();
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
                    child: Text(
                      'Game Rates',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 80, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width,
                child: !_showProgress
                    ? ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(5),
                        children: [
                          Text(
                            'GAME WIN RATIO FOR ALL BIDS',
                            style: TextStyle(color: Colors.teal),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          listOfMarketGameRates.length > 0
                              ? Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          'GAME RATES',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      buildListOfMarketGameRates(),
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          listOfStarlineGameRates.length > 0
                              ? Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Starline Rates',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      buildListOfStarlineGameRates(),
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          listOfJackpotGameRates.length > 0
                              ? Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Jackpot Rates',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      buildListOfJackpotGameRates(),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : Container(
                        width: 100,
                        child: CircularProgressIndicator(),
                      ),
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

    setState(() {
      _showProgress = true;
    });

    HTTPService().fetchGameRate(authToken).then((response) {
      setState(() {
        _showProgress = false;
      });
      if (response.statusCode == 200) {
        displayData(response);
      } else {
        showErrorDialog('Game Rate fetching failed');
      }
    });

    HTTPService().fetchStarlineRate(authToken).then((response) {
      setState(() {
        _showProgress = false;
      });
      if (response.statusCode == 200) {
        displayStarlineData(response);
      } else {
        showErrorDialog('Game Rate fetching failed');
      }
    });

    HTTPService().fetchJackpotRate(authToken).then((response) {
      setState(() {
        _showProgress = false;
      });
      if (response.statusCode == 200) {
        displayJackpotData(response);
      } else {
        showErrorDialog('Game Rate fetching failed');
      }
    });
  }

  displayData(Response response) {
    GameRateResponseModel gameRateResponseModel =
        GameRateResponseModel.fromJson(json.decode(response.body));

    if (gameRateResponseModel.status) {
      if (mounted) {
        setState(() {
          listOfMarketGameRates = gameRateResponseModel.data;
        });
      }
    } else {
      showErrorDialog(gameRateResponseModel.message == null
          ? 'Data could not be fetched!'
          : gameRateResponseModel.message);
    }
  }

  displayStarlineData(Response response) {
    GameRateResponseModel gameRateResponseModel =
        GameRateResponseModel.fromJson(json.decode(response.body));

    if (gameRateResponseModel.status) {
      if (mounted) {
        setState(() {
          listOfStarlineGameRates = gameRateResponseModel.data;
        });
      }
    } else {
      // showErrorDialog(gameRateResponseModel.message == null
      //     ? 'Data could not be fetched!'
      //     : gameRateResponseModel.message);
    }
  }

  displayJackpotData(Response response) {
    GameRateResponseModel gameRateResponseModel =
        GameRateResponseModel.fromJson(json.decode(response.body));

    if (gameRateResponseModel.status) {
      if (mounted) {
        setState(() {
          listOfJackpotGameRates = gameRateResponseModel.data;
        });
      }
    } else {
      // showErrorDialog(gameRateResponseModel.message == null
      //     ? 'Data could not be fetched!'
      //     : gameRateResponseModel.message);
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

  Widget buildListOfMarketGameRates() {
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
                width: 100,
                child: Text(
                  listOfMarketGameRates[index].gametype == null
                      ? ""
                      : '${listOfMarketGameRates[index].gametype}',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 20,
                child: Text(
                  ' - ',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: Text(
                '10',
                style: TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center,
              )),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 20,
                child: Text(
                  ' = ',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  listOfMarketGameRates[index].bhouAmt,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
      itemCount: listOfMarketGameRates.length,
    );
  }

  Widget buildListOfJackpotGameRates() {
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
                width: 100,
                child: Text(
                  listOfJackpotGameRates[index].gametype == null
                      ? ""
                      : '${listOfJackpotGameRates[index].gametype}',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 20,
                child: Text(
                  ' - ',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: Text(
                '10',
                style: TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center,
              )),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 20,
                child: Text(
                  ' = ',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  listOfJackpotGameRates[index].bhouAmt,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
      itemCount: listOfJackpotGameRates.length,
    );
  }

  Widget buildListOfStarlineGameRates() {
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
                width: 100,
                child: Text(
                  listOfStarlineGameRates[index].gametype == null
                      ? ""
                      : '${listOfStarlineGameRates[index].gametype}',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 20,
                child: Text(
                  ' - ',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: Text(
                '10',
                style: TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center,
              )),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 20,
                child: Text(
                  ' = ',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  listOfStarlineGameRates[index].bhouAmt,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
      itemCount: listOfStarlineGameRates.length,
    );
  }
}
