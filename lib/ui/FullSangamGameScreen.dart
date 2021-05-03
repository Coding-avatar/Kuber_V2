import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kuber_starline/app_models/played_game_model.dart';
import 'package:kuber_starline/constants/game_type_constants.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/marquee_text.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/bid_model.dart';
import 'package:kuber_starline/network/models/bid_submit_response.dart';
import 'package:kuber_starline/network/models/game_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullSangamGameScreen extends StatefulWidget {
  final GameData gameData;
  final String gameType;
  final int gameConstant;
  final String bettingTime;

  FullSangamGameScreen(
      {@required this.gameData,
      @required this.gameType,
      @required this.gameConstant,
      @required this.bettingTime});

  @override
  _FullSangamGameScreenState createState() => _FullSangamGameScreenState();
}

class _FullSangamGameScreenState extends State<FullSangamGameScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> openPannaKey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> closePannaKey = new GlobalKey();

  GameData gameData;
  String gameType;
  int gameConstant;
  String bettingTime;
  String authToken = "";
  String walletBalance = "";
  String minBetAmount = "";

  DateFormat dateFormat = new DateFormat("dd-MM-yyyy");
  DateTime todayDate;
  List<String> listOfAvailableDates = List();
  List<String> listOfDayNames = List();
  List<String> suggestionsList = List();
  List<PlayedGameModel> listOfPlayedGames = List();
  String selectedDate = "";
  String selectedGameTime = "";
  String selectedGameTimeString = "";

  TextEditingController openPannaController;
  TextEditingController closePannaController;
  TextEditingController pointsController;

  bool _showProgress = false;
  int playedDigit = -1;
  int pointsPlayed = -1;
  int openPannaPlayed = -1;
  int closePannaPlayed = -1;
  int index = 1;

  @override
  void initState() {
    super.initState();
    gameData = widget.gameData;
    gameType = widget.gameType;
    gameConstant = widget.gameConstant;
    bettingTime = widget.bettingTime;
    todayDate = DateTime.now();
    selectedDate = dateFormat.format(todayDate);

    minBetAmount =
        gameData.minData != null ? gameData.minData[0].minbetamount : '0';

    openPannaController = TextEditingController();
    closePannaController = TextEditingController();
    pointsController = TextEditingController();

    getUserDetails();
    getAvailableDates();
    fillSuggestionsList();
  }

  @override
  void dispose() {
    super.dispose();
    pointsController.dispose();
    openPannaController.dispose();
    closePannaController.dispose();
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
                '${gameData.gamename} ($gameType)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
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
              Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.fromLTRB(10, 100, 10, 0),
                child: Column(
                  children: [
                    InkWell(
                      child: Container(
                          padding: EdgeInsets.all(8),
                          width: 150,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.red,
                                size: 16,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                selectedDate.isEmpty
                                    ? 'SELECT DATE'
                                    : selectedDate,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      onTap: () {
                        showDateDialog(context);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            'OPEN PANNA',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 40,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          child: SimpleAutoCompleteTextField(
                            key: openPannaKey,
                            keyboardType: TextInputType.number,
                            controller: openPannaController,
                            suggestions: suggestionsList,
                            clearOnSubmit: false,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
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
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            'CLOSE PANNA',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 40,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          child: SimpleAutoCompleteTextField(
                            key: closePannaKey,
                            keyboardType: TextInputType.number,
                            controller: closePannaController,
                            suggestions: suggestionsList,
                            clearOnSubmit: false,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
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
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            'POINT',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 40,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: pointsController,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          if (pointsController.text.isNotEmpty &&
                              openPannaController.text.isNotEmpty &&
                              closePannaController.text.isNotEmpty &&
                              int.parse(pointsController.text.trim()) <=
                                  int.parse(walletBalance))
                            addToPlayedGames();
                          else {
                            if (openPannaController.text.isEmpty)
                              showErrorDialog(
                                  'Please select open panna to play');
                            else if (closePannaController.text.isEmpty)
                              showErrorDialog(
                                  'Please select close panna to play');
                            else if (pointsController.text.isEmpty)
                              showErrorDialog('Please enter amount to play');
                            else if (int.parse(pointsController.text.trim()) >=
                                int.parse(walletBalance))
                              showErrorDialog(
                                  'Minimum bet amount is $minBetAmount');
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
                                gameConstant == GameTypeConstants.JODI_DIGIT
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
                                        DataCell(Text(
                                            element.playedDigit.toString())),
                                        DataCell(Text(
                                            element.pointsPlayed.toString())),
                                        DataCell(InkWell(
                                          child: Icon(
                                            Icons.delete_forever_rounded,
                                            size: 34,
                                            color: Colors.red,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              walletBalance =
                                                  (int.parse(walletBalance) +
                                                          element.pointsPlayed)
                                                      .toString();
                                              listOfPlayedGames.remove(element);
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
                  child: !_showProgress
                      ? MaterialButton(
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
                        )
                      : Container(),
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
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);
    setState(() {
      walletBalance =
          sharedPreferences.getString(Constants.SHARED_PREF_WALLET_BALANCE);
    });
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

  void fillSuggestionsList() {
    suggestionsList = [
      '100',
      '110',
      '112',
      '113',
      '114',
      '115',
      '116',
      '117',
      '118',
      '119',
      '120',
      '122',
      '123',
      '124',
      '125',
      '126',
      '127',
      '128',
      '129',
      '130',
      '133',
      '134',
      '135',
      '136',
      '137',
      '138',
      '139',
      '140',
      '144',
      '145',
      '146',
      '147',
      '148',
      '149',
      '150',
      '155',
      '156',
      '157',
      '158',
      '159',
      '160',
      '166',
      '167',
      '170',
      '177',
      '178',
      '179',
      '180',
      '188',
      '189',
      '190',
      '199',
      '200',
      '220',
      '223',
      '224',
      '225',
      '226',
      '227',
      '228',
      '229',
      '230',
      '233',
      '234',
      '235',
      '236',
      '237',
      '238',
      '239',
      '240',
      '244',
      '245',
      '246',
      '247',
      '248',
      '249',
      '250',
      '255',
      '256',
      '257',
      '258',
      '259',
      '260',
      '266',
      '267',
      '268',
      '269',
      '270',
      '277',
      '278',
      '279',
      '280',
      '288',
      '290',
      '299',
      '300',
      '330',
      '334',
      '335',
      '336',
      '337',
      '338',
      '339',
      '340',
      '344',
      '345',
      '346',
      '347',
      '348',
      '349',
      '350',
      '355',
      '356',
      '357',
      '358',
      '359',
      '360',
      '366',
      '367',
      '368',
      '369',
      '370',
      '377',
      '378',
      '379',
      '380',
      '388',
      '389',
      '390',
      '399',
      '400',
      '440',
      '445',
      '446',
      '447',
      '448',
      '449',
      '450',
      '455',
      '456',
      '457',
      '458',
      '459',
      '460',
      '466',
      '467',
      '468',
      '469',
      '470',
      '477',
      '478',
      '479',
      '480',
      '488',
      '489',
      '490',
      '499',
      '500',
      '550',
      '556',
      '557',
      '558',
      '559',
      '560',
      '566',
      '567',
      '568',
      '569',
      '570',
      '577',
      '578',
      '579',
      '580',
      '588',
      '589',
      '590',
      '599',
      '600',
      '660',
      '667',
      '668',
      '669',
      '670',
      '677',
      '678',
      '679',
      '680',
      '688',
      '689',
      '690',
      '699',
      '700',
      '770',
      '778',
      '779',
      '780',
      '788',
      '789',
      '790',
      '799',
      '800',
      '880',
      '889',
      '890',
      '899',
      '900',
      '990',
      '000'
    ];
  }

  void addToPlayedGames() {
    selectedGameTime = bettingTime;

    if (int.parse(pointsController.text.trim()) <= int.parse(walletBalance) &&
        int.parse(pointsController.text.trim()) >= int.parse(minBetAmount)) {
      if (openPannaController.text.isNotEmpty &&
          closePannaController.text.isNotEmpty &&
          checkPannaValueExists(openPannaController.text.trim()) &&
          checkPannaValueExists(closePannaController.text.trim()) &&
          selectedDate.isNotEmpty &&
          selectedGameTime.isNotEmpty) {
        pointsPlayed = int.parse(pointsController.text.trim());
        openPannaPlayed = int.parse(openPannaController.text.trim());
        closePannaPlayed = int.parse(closePannaController.text.trim());

        playedDigit = int.parse('$openPannaPlayed$closePannaPlayed');

        setState(() {
          walletBalance = (int.parse(walletBalance) - pointsPlayed).toString();
        });

        PlayedGameModel playedGameModel = PlayedGameModel(
            index: index,
            gameId: gameData.pkUserCreation,
            gameName: gameData.gamename,
            playedDigit: playedDigit,
            pointsPlayed: pointsPlayed,
            gameDate: selectedDate,
            gameTime: selectedGameTime,
            finalAmount: walletBalance);

        setState(() {
          listOfPlayedGames.add(playedGameModel);

          pointsController.text = "";
          openPannaController.text = "";
          closePannaController.text = "";

          selectedDate = '';
          selectedGameTime = '';
          selectedGameTimeString = '';
        });

        // global variable to keep count of the entries
        index += 1;
      } else {
        if (selectedDate.isEmpty)
          showErrorDialog('Please select date to play');
        else if (selectedGameTime.isEmpty)
          showErrorDialog('Please select game time to play');
        else if (pointsController.text.isEmpty)
          showErrorDialog('Please enter point to play on');
        else if (openPannaController.text.isEmpty)
          showErrorDialog('Please selet open panna to play on');
        else if (closePannaController.text.isEmpty)
          showErrorDialog('Please select close panna to play on');
        else if (!checkPannaValueExists(openPannaController.text))
          showErrorDialog('Open Panna not available');
        else if (!checkPannaValueExists(closePannaController.text))
          showErrorDialog('Close Panna not available');
      }
    } else {
      if (int.parse(pointsController.text.trim()) > int.parse(walletBalance))
        showErrorDialog('Insufficient Wallet Balance');
      else if (int.parse(pointsController.text.trim()) <
          int.parse(minBetAmount))
        showErrorDialog('Minimum bet amount is $minBetAmount');
    }
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
          openPannaController.text = "";
          closePannaController.text = "";
          pointsController.text = "";

          listOfPlayedGames = List();
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
}
