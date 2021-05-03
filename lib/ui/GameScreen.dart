import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kuber_starline/app_models/played_game_model.dart';
import 'package:kuber_starline/constants/game_type_constants.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/customs/utility_methods.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/bid_model.dart';
import 'package:kuber_starline/network/models/bid_submit_response.dart';
import 'package:kuber_starline/network/models/game_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  final GameData gameData;
  final String gameType;
  final int gameConstant;
  final bool isJackpot;
  final String selectedJackpotTime;
  final bool isStarline;

  GameScreen(
      {@required this.gameData,
      @required this.gameType,
      this.gameConstant,
      @required this.isJackpot,
      @required this.selectedJackpotTime,
      @required this.isStarline});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  GameData gameData;
  String gameType;
  int gameConstant;
  bool _isJackpot = false;
  String selectedJackpotTime = "";
  bool _isStarline = false;

  String minBetAmount = "";

  DateTime todayDate;
  List<String> listOfAvailableDates = List();
  List<String> listOfDayNames = List();
  String walletbalance = "";
  String selectedDate = "";
  String selectedGameTime = "";
  String selectedGameTimeString = "";
  int playedDigit = -1;
  int pointsPlayed = -1;
  int index = 1;

  DateFormat dateFormat = new DateFormat("dd-MM-yyyy");
  List<String> suggestionsList = List();
  List<PlayedGameModel> listOfPlayedGames = List();

  TextEditingController digitsController;
  TextEditingController pointsController;
  String authToken = "";

  bool _showProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gameData = widget.gameData;
    gameType = widget.gameType;
    gameConstant = widget.gameConstant;
    _isJackpot = widget.isJackpot;
    _isStarline = widget.isStarline;
    selectedJackpotTime = widget.selectedJackpotTime;

    minBetAmount = gameData.minData != null && gameData.minData.isNotEmpty
        ? gameData.minData[0].minbetamount
        : "10";

    todayDate = DateTime.now();
    selectedDate = dateFormat.format(todayDate);

    getAuthToken();
    getWalletBalance();
    getAvailableDates();
    checkIfOpenTimePassed();
    fillSuggestionsList();

    digitsController = TextEditingController();
    pointsController = TextEditingController();
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
              title: Text(
                '${gameData.gamename} ($gameType)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              centerTitle: false,
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
                      walletbalance.isNotEmpty
                          ? Text(
                              '\u{20B9}$walletbalance',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )
                          : Text(
                              '\u{20B9}0',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
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
                      margin: EdgeInsets.fromLTRB(10, 100, 5, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Text(
                                    selectedDate.isEmpty
                                        ? '\u{1F4C5}  SELECT DATE'
                                        : selectedDate,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onTap: () {
                                  showDateDialog(context);
                                },
                              ),
                              gameConstant != GameTypeConstants.JODI_DIGIT &&
                                      !_isStarline &&
                                      gameConstant !=
                                          GameTypeConstants.LEFT_DIGIT &&
                                      gameConstant !=
                                          GameTypeConstants.RIGHT_DIGIT
                                  ? InkWell(
                                      child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                          ),
                                          child: Row(
                                            children: [
                                              selectedGameTime.isNotEmpty
                                                  ? Icon(
                                                      Icons.alarm,
                                                      color: Colors.red,
                                                      size: 20,
                                                    )
                                                  : Container(),
                                              selectedGameTime.isNotEmpty
                                                  ? SizedBox(
                                                      width: 15,
                                                    )
                                                  : Container(),
                                              Text(
                                                selectedGameTime.isEmpty
                                                    ? 'SELECT GAME TIME'
                                                    : selectedGameTimeString,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          )),
                                      onTap: () {
                                        if (selectedDate.isNotEmpty) {
                                          if (selectedDate ==
                                              dateFormat.format(todayDate)) {
                                            bool showOpen =
                                                UtilityMethodsManager()
                                                    .findDifference(
                                                        gameData.slot2Time1);
                                            bool showClose =
                                                UtilityMethodsManager()
                                                    .findDifference(
                                                        gameData.slot2Time2);

                                            if (showOpen || showClose) {
                                              showGameTypesAvailable(
                                                  context, showOpen, showClose);
                                            } else {
                                              showErrorDialog(
                                                  'Oops! Market is closed for the day!');
                                            }
                                          } else {
                                            showGameTypesAvailable(
                                                context, true, true);
                                          }
                                        }
                                      },
                                    )
                                  : Container(),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                gameType,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              (gameConstant ==
                                          GameTypeConstants.Single_DIGITS ||
                                      _isJackpot)
                                  ? Container(
                                      width: 120,
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: digitsController,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                        inputFormatters: gameConstant ==
                                                    GameTypeConstants
                                                        .Single_DIGITS ||
                                                gameConstant ==
                                                    GameTypeConstants
                                                        .LEFT_DIGIT ||
                                                gameConstant ==
                                                    GameTypeConstants
                                                        .RIGHT_DIGIT
                                            ? [
                                                LengthLimitingTextInputFormatter(
                                                    1),
                                              ]
                                            : gameConstant ==
                                                    GameTypeConstants.JODI_DIGIT
                                                ? [
                                                    LengthLimitingTextInputFormatter(
                                                        2),
                                                  ]
                                                : [
                                                    LengthLimitingTextInputFormatter(
                                                        3),
                                                  ],
                                        decoration: new InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white),
                                      ),
                                    )
                                  : Container(
                                      width: 120,
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: SimpleAutoCompleteTextField(
                                        key: key,
                                        keyboardType: TextInputType.number,
                                        controller: digitsController,
                                        suggestions: suggestionsList,
                                        clearOnSubmit: false,
                                        decoration: new InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Points',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: 120,
                                height: 40,
                                alignment: Alignment.center,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: pointsController,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: MaterialButton(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              minWidth: 120,
                              color: Colors.red,
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                int points =
                                    int.parse(pointsController.text.trim());
                                if (points <= int.parse(walletbalance))
                                  addToPlayedGames();
                                else {
                                  showErrorDialog(
                                      'Insufficient wallet balance');
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DataTable(
                            columnSpacing: 30,
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            headingTextStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                            dataTextStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                            columns: [
                              DataColumn(
                                  label: Text('No',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ))),
                              DataColumn(
                                  label: Text('Game',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ))),
                              DataColumn(
                                  label: Text(
                                      gameConstant ==
                                              GameTypeConstants.JODI_DIGIT
                                          ? 'Jodi'
                                          : 'Digit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ))),
                              DataColumn(
                                  label: Text('Point',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ))),
                              DataColumn(
                                  label: Text('Action',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ],
                            rows: listOfPlayedGames.isEmpty
                                ? []
                                : listOfPlayedGames // Loops through dataColumnText, each iteration assigning the value to element
                                    .map(
                                      ((element) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(
                                                element.index.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              )),
                                              //Extracting from Map element the value
                                              DataCell(Text(element.gameName)),
                                              DataCell(Text(element.playedDigit
                                                  .toString())),
                                              DataCell(Text(element.pointsPlayed
                                                  .toString())),
                                              DataCell(InkWell(
                                                child: Icon(
                                                  Icons.delete_forever_rounded,
                                                  size: 34,
                                                  color: Colors.red,
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    walletbalance = (int.parse(
                                                                walletbalance) +
                                                            element
                                                                .pointsPlayed)
                                                        .toString();
                                                    listOfPlayedGames
                                                        .remove(element);
                                                  });
                                                },
                                              )),
                                            ],
                                          )),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                        child: MaterialButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          minWidth: 120,
                          color: Colors.red,
                          child: Text(
                            'Submit Bid',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            submitBids();
                          },
                        ),
                      ),
                    ),
                    _showProgress
                        ? Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          )
                        : Container(),
                  ],
                ),
              ),
            )),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();

    return true;
  }

  void showDateDialog(BuildContext buildContext) {
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            content: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              // height: MediaQuery.of(context).size.height / 2.5,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      color: Colors.red,
                      child: Text(
                        'SELECT DATE',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Material(
                          child: InkWell(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 0, 15),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.2, color: Colors.grey)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        child: Text(
                                          listOfAvailableDates.length != 0
                                              ? listOfAvailableDates[index]
                                              : 'DATE TODAY',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: Text(
                                          listOfDayNames.length != 0
                                              ? listOfDayNames[index]
                                              : 'Day Name',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    width: 100,
                                    child: Text(
                                      'Bet Open',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedDate = listOfAvailableDates[index];

                                selectedGameTime = '';
                                selectedGameTimeString = '';
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                      itemCount: 4,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showGameTypesAvailable(
      BuildContext buildContext, bool showOpen, bool showClose) {
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            content: Container(
              width: 80,
              height: 150,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      color: Colors.red,
                      child: Text(
                        'GAME TYPE',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    showOpen
                        ? Material(
                            child: InkWell(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 0, 15),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.2, color: Colors.grey)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.alarm_on_rounded,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Open',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedGameTime = gameData.slot2Time1;
                                  selectedGameTimeString = 'Open';
                                });

                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    showClose
                        ? Material(
                            child: InkWell(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 0, 15),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.2, color: Colors.grey)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.alarm_off_rounded,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Close',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedGameTime = gameData.slot2Time2;
                                  selectedGameTimeString = 'Close';
                                });

                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        });
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

  void getAvailableDates() {
    // counter for the days
    int i = 0;
    DateFormat dateNameFormat = DateFormat('EEE');

    while (listOfAvailableDates.length != 4) {
      DateTime dateTime = todayDate.add(Duration(days: i));
      String newDate = dateFormat.format(dateTime);
      String newDateName = dateNameFormat.format(dateTime);

      if (gameData.dayData.contains(newDateName) &&
          (gameData.holidayData == null ||
              !gameData.holidayData.contains(newDate))) {
        listOfAvailableDates.add(newDate);
        listOfDayNames.add(DateFormat('EEEE').format(dateTime));
      }

      // increase another day
      i += 1;
    }
  }

  List<String> suggestionForSinglePanna() {
    return [
      '128',
      '137',
      '146',
      '236',
      '245',
      '290',
      '380',
      '470',
      '489',
      '560',
      '678',
      '579',
      '129',
      '138',
      '147',
      '156',
      '237',
      '246',
      '354',
      '390',
      '480',
      '570',
      '679',
      '589',
      '120',
      '139',
      '148',
      '157',
      '238',
      '247',
      '256',
      '346',
      '490',
      '580',
      '670',
      '689',
      '130',
      '149',
      '158',
      '167',
      '239',
      '248',
      '257',
      '347',
      '356',
      '590',
      '680',
      '789',
      '159',
      '168',
      '230',
      '249',
      '258',
      '140',
      '267',
      '348',
      '357',
      '456',
      '690',
      '780',
      '123',
      '150',
      '169',
      '178',
      '240',
      '259',
      '268',
      '349',
      '358',
      '457',
      '367',
      '790',
      '124',
      '160',
      '179',
      '250',
      '269',
      '278',
      '340',
      '359',
      '368',
      '458',
      '467',
      '890',
      '125',
      '134',
      '170',
      '189',
      '260',
      '279',
      '350',
      '369',
      '378',
      '459',
      '567',
      '468',
      '126',
      '135',
      '180',
      '234',
      '270',
      '289',
      '360',
      '379',
      '450',
      '469',
      '478',
      '568',
      '127',
      '136',
      '145',
      '190',
      '235',
      '280',
      '370',
      '479',
      '460',
      '569',
      '389',
      '578',
    ];
  }

  List<String> suggestionForDoublePanna() {
    return [
      '100',
      '119',
      '155',
      '227',
      '335',
      '344',
      '399',
      '588',
      '669',
      '200',
      '110',
      '228',
      '255',
      '336',
      '499',
      '600',
      '688',
      '778',
      '300',
      '166',
      '299',
      '337',
      '355',
      '445',
      '599',
      '779',
      '788',
      '400',
      '112',
      '220',
      '266',
      '338',
      '446',
      '455',
      '699',
      '770',
      '500',
      '113',
      '122',
      '177',
      '339',
      '366',
      '447',
      '799',
      '889',
      '700',
      '114',
      '277',
      '330',
      '448',
      '466',
      '556',
      '880',
      '899',
      '800',
      '116',
      '224',
      '233',
      '288',
      '440',
      '477',
      '558',
      '990',
      '900',
      '117',
      '144',
      '199',
      '225',
      '388',
      '559',
      '577',
      '667',
      '550',
      '668',
      '244',
      '299',
      '226',
      '488',
      '677',
      '118',
      '334'
    ];
  }

  void fillSuggestionsList() {
    switch (gameConstant) {
      case GameTypeConstants.Single_PANNA:
        suggestionsList = suggestionForSinglePanna();
        break;
      case GameTypeConstants.Double_PANNA:
        suggestionsList = suggestionForDoublePanna();
        break;
      case GameTypeConstants.Triple_PANNA:
        suggestionsList = suggestionForTriplePanna();
        break;
      case GameTypeConstants.Single_DIGITS:
        suggestionsList = suggestionForSingleDigit();
        break;
      case GameTypeConstants.JODI_DIGIT:
        suggestionsList = suggestionForJodiDigit();
        break;
    }
  }

  void addToPlayedGames() {
    if (_isStarline || _isJackpot) selectedGameTime = selectedJackpotTime;

    if (!_isJackpot && !_isStarline) {
      if (int.parse(pointsController.text.trim()) <= int.parse(walletbalance) &&
          int.parse(pointsController.text.trim()) >= int.parse(minBetAmount)) {
        if (gameConstant == GameTypeConstants.JODI_DIGIT)
          selectedGameTime = selectedJackpotTime;
        if (digitsController.text.isNotEmpty &&
            pointsController.text.isNotEmpty &&
            checkPannaValueExists(digitsController.text.trim()) &&
            selectedDate.isNotEmpty &&
            selectedGameTime.isNotEmpty) {
          playedDigit = int.parse(digitsController.text.trim());
          pointsPlayed = int.parse(pointsController.text.trim());

          setState(() {
            walletbalance =
                (int.parse(walletbalance) - pointsPlayed).toString();
          });

          PlayedGameModel playedGameModel = PlayedGameModel(
              index: index,
              gameId: gameData.pkUserCreation,
              gameName: gameData.gamename,
              playedDigit: playedDigit,
              pointsPlayed: pointsPlayed,
              gameDate: selectedDate,
              gameTime: selectedGameTime,
              finalAmount: walletbalance);

          setState(() {
            listOfPlayedGames.add(playedGameModel);

            pointsController.text = "";
            digitsController.text = "";

            // selectedDate = '';
            // selectedGameTime = '';
            // selectedGameTimeString = '';
          });

          // global variable to keep count of the entries
          index += 1;
        } else {
          if (selectedDate.isEmpty)
            showErrorDialog('Please select date to play');
          else if (selectedGameTime.isEmpty)
            showErrorDialog('Please select game time to play');
          else if (digitsController.text.isEmpty)
            showErrorDialog('Please enter digit to play on');
          else if (pointsController.text.isEmpty)
            showErrorDialog('Please enter digit to play on');
          else if (!checkPannaValueExists(digitsController.text))
            showErrorDialog('Invalid panna value');
        }
      } else {
        if (int.parse(pointsController.text.trim()) > int.parse(walletbalance))
          showErrorDialog('Insufficient Wallet Balance');
        else if (int.parse(pointsController.text.trim()) <
            int.parse(minBetAmount))
          showErrorDialog('Minimum bet amount is $minBetAmount');
      }
    } else {
      if (int.parse(pointsController.text.trim()) <= int.parse(walletbalance) &&
          int.parse(pointsController.text.trim()) >= int.parse(minBetAmount)) {
        if (digitsController.text.isNotEmpty &&
            pointsController.text.isNotEmpty &&
            selectedDate.isNotEmpty &&
            selectedGameTime.isNotEmpty) {
          playedDigit = int.parse(digitsController.text.trim());
          pointsPlayed = int.parse(pointsController.text.trim());

          setState(() {
            walletbalance =
                (int.parse(walletbalance) - pointsPlayed).toString();
          });

          PlayedGameModel playedGameModel = PlayedGameModel(
              index: index,
              gameId: gameData.pkUserCreation,
              gameName: gameData.gamename,
              playedDigit: playedDigit,
              pointsPlayed: pointsPlayed,
              gameDate: selectedDate,
              gameTime: selectedGameTime,
              finalAmount: walletbalance);

          setState(() {
            listOfPlayedGames.add(playedGameModel);

            pointsController.text = "";
            digitsController.text = "";

            // selectedDate = '';
            // selectedGameTime = '';
            // selectedGameTimeString = '';
          });

          // global variable to keep count of the entries
          index += 1;
        } else {
          if (selectedDate.isEmpty)
            showErrorDialog('Please select date to play');
          else if (selectedGameTime.isEmpty)
            showErrorDialog('Please select game time to play');
          else if (digitsController.text.isEmpty)
            showErrorDialog('Please enter digit to play on');
          else if (pointsController.text.isEmpty)
            showErrorDialog('Please enter digit to play on');
        }
      } else {
        if (int.parse(pointsController.text.trim()) > int.parse(walletbalance))
          showErrorDialog('Insufficient Wallet Balance');
        else if (int.parse(pointsController.text.trim()) <
            int.parse(minBetAmount))
          showErrorDialog('Minimum bet amount is $minBetAmount');
      }
    }
  }

  void getWalletBalance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      walletbalance =
          sharedPreferences.getString(Constants.SHARED_PREF_WALLET_BALANCE);
    });
  }

  void submitBids() async {
    int totalPointsPlayed = 0;
    List<BidModel> listOfBids = List();

    if (listOfPlayedGames.length > 0) {
      print('Games played: ${listOfPlayedGames.length}');

      for (int i = 0; i < listOfPlayedGames.length; i++) {
        // used to update wallet balance
        totalPointsPlayed += listOfPlayedGames[i].pointsPlayed;
        PlayedGameModel playedGameModel = listOfPlayedGames[i];
        BidModel bidModel = BidModel(
          gameId: playedGameModel.gameId.toString(),
          gametype: gameType,
          date: playedGameModel.gameDate,
          gameTime: playedGameModel.gameTime,
          betamount: playedGameModel.pointsPlayed.toString(),
          betpoints: playedGameModel.playedDigit.toString(),
          finalAmount: playedGameModel.finalAmount,
        );

        listOfBids.add(bidModel);
      }

      setState(() {
        _showProgress = true;
      });

      print('Submit bid: ${jsonEncode({'data': listOfBids}).toString()}');

      HTTPService().submitBid(authToken, listOfBids).then((response) {
        setState(() {
          listOfPlayedGames.clear();
          _showProgress = false;
        });

        if (response.statusCode == 200) {
          showSuccessDialog(context, response.body, totalPointsPlayed);
        } else {
          showErrorDialog(response.body);
        }
      });
    } else {
      showErrorDialog('No bets places!');
    }
  }

  bool checkPannaValueExists(String value) {
    if (suggestionsList.contains(value))
      return true;
    else
      return false;
  }

  List<String> suggestionForTriplePanna() {
    return [
      '000',
      '111',
      '222',
      '333',
      '444',
      '555',
      '666',
      '777',
      '888',
      '999'
    ];
  }

  void showSuccessDialog(
      BuildContext buildContext, String body, int totalPointsPlayed) {
    var bidSubmitResponse = BidSubmitResponse.fromJson(json.decode(body));

    if (bidSubmitResponse.status) {
      if (mounted) {
        setState(() {
          _showProgress = false;

          selectedDate = dateFormat.format(todayDate);
          selectedGameTime = "";
          selectedGameTimeString = "";
          digitsController.text = "";
          pointsController.text = "";

          listOfPlayedGames = List();
        });

        SharedPreferences.getInstance().then((sharedPrefs) {
          sharedPrefs.setString(
              Constants.SHARED_PREF_WALLET_BALANCE, walletbalance);
        });

        SharedPreferences.getInstance().then((sharedPrefs) {
          sharedPrefs.setString(
              Constants.SHARED_PREF_WALLET_BALANCE, walletbalance);
        });

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
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(32.0)),
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
                            'Congratulations! Bid played successfully!',
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
    } else {
      showErrorDialog(bidSubmitResponse.message);
    }
  }

  List<String> suggestionForSingleDigit() {
    return ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
  }

  void getAuthToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);
  }

  List<String> suggestionForJodiDigit() {
    return [
      "00",
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
      '32',
      '33',
      '34',
      '35',
      '36',
      '37',
      '38',
      '39',
      '40',
      '41',
      '42',
      '43',
      '44',
      '45',
      '46',
      '47',
      '48',
      '49',
      '50',
      '51',
      '52',
      '53',
      '54',
      '55',
      '56',
      '57',
      '58',
      '59',
      '60',
      '61',
      '62',
      '63',
      '64',
      '65',
      '66',
      '67',
      '68',
      '69',
      '70',
      '71',
      '72',
      '73',
      '74',
      '75',
      '76',
      '77',
      '78',
      '79',
      '80',
      '81',
      '82',
      '83',
      '84',
      '85',
      '86',
      '87',
      '88',
      '89',
      '90',
      '91',
      '92',
      '93',
      '94',
      '95',
      '96',
      '97',
      '98',
      '99',
    ];
  }

  void checkIfOpenTimePassed() {
    if (!UtilityMethodsManager().findDifference(gameData.slot2Time1)) {
      setState(() {
        selectedGameTime = gameData.slot2Time2;
        selectedGameTimeString = 'Close';
      });
    }
  }
}
