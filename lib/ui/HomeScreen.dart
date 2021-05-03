import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:intl/intl.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/customs/utility_methods.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/all_games_response_model.dart';
import 'package:kuber_starline/network/models/game_model.dart';
import 'package:kuber_starline/network/models/get_banner_response_model.dart';
import 'package:kuber_starline/network/models/get_wallet_response_model.dart';
import 'package:kuber_starline/network/models/starjackdetails_response_model.dart';
import 'package:kuber_starline/network/models/wallet_model.dart';
import 'package:kuber_starline/ui/ChatScreen.dart';
import 'package:kuber_starline/ui/GameDashboard.dart';
import 'package:kuber_starline/ui/HistoryScreen.dart';
import 'package:kuber_starline/ui/NotificationsScreen.dart';
import 'package:kuber_starline/ui/WalletScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'file:///D:/Flutter%20Projects/kuber_starline_v2/kuber_starline/lib/ui/JackpotDashboardScreen.dart';

import 'StarlineGameScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOpenDrawer = false;
  bool _hasFetchedGames = false;
  bool _showProgress = false;
  String authToken = "";

  List<GameData> listOfGames = List();
  WalletData _walletData;
  String walletBalance = "";

  String todayDay = "";
  String todayDate = "";
  DateTime dateToday;

  List<String> bannerUrl = List();
  List<String> redirectUrl = List();
  String supportNumber = "";

  @override
  void initState() {
    super.initState();

    fetchAuthToken();
    dateToday = DateTime.now();
    todayDay = DateFormat('EEE').format(dateToday);
    todayDate = DateFormat('dd-MM-yyyy').format(dateToday);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          switch (index) {
            case 0:
              _onRefresh();
              break;
            case 1:
              Navigator.of(context).push(ScaleRoute(page: HistoryScreen()));
              break;
            case 2:
              Navigator.of(context).push(ScaleRoute(page: WalletScreen()));
              break;
            case 3:
              Navigator.of(context).push(ScaleRoute(page: ChatScreen()));
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.refresh_outlined,
              size: 24,
            ),
            label: 'Refresh',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              size: 24,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet_rounded,
              size: 24,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_outlined),
            label: 'Support',
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
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
              child: InkWell(
                child: !isOpenDrawer
                    ? Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 26,
                      )
                    : Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 26,
                      ),
                onTap: () {
                  if (!Scaffold.of(context).isDrawerOpen)
                    Scaffold.of(context).openDrawer();
                  else
                    Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.fromLTRB(40, 40, 0, 0),
              child: Text(
                'Ratan Matka',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 45, 0),
                  height: 40,
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _walletData != null
                            ? '\u{20B9}$walletBalance'
                            : "\u{20B9}0",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(ScaleRoute(page: WalletScreen()));
                },
              )),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 30, 5, 0),
                height: 40,
                width: 30,
                child: Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(ScaleRoute(page: NotificationsScreen()));
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 140,
            margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 135,
                  child: bannerUrl != null && bannerUrl.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.white)),
                          child: Carousel(
                              dotSize: 5.0,
                              dotSpacing: 20.0,
                              dotIncreasedColor: Colors.red,
                              dotColor: Colors.white,
                              indicatorBgPadding: 10.0,
                              dotBgColor: Colors.transparent,
                              borderRadius: true,
                              noRadiusForIndicator: true,
                              images: bannerUrl
                                  .map((url) => InkWell(
                                        child: ClipRRect(
                                          child: Image.network(
                                            url,
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        onTap: () {
                                          launchUrl();
                                        },
                                      ))
                                  .toList()),
                        )
                      : Container(
                          width: 180,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/ic_whatsapp.png',
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '$supportNumber',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(ScaleRoute(page: ChatScreen()));
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonTheme(
                        minWidth: 150,
                        height: 50.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/play_button.png',
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'PLAY STARLINE',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              )
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(ScaleRoute(page: StarlineGameScreen()));
                          },
                          elevation: 12,
                          color: Colors.blue,
                          splashColor: Colors.white,
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 150,
                        height: 50.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.transparent, width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/play_button.png',
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'PLAY JACKPOT',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    JackpotDashboardScreen()));
                          },
                          elevation: 12,
                          color: Color(0xFFFFCCCB),
                          splashColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                _hasFetchedGames
                    ? Expanded(
                        child: buildListOfGames(),
                      )
                    : Container(),
              ],
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
    );
  }

  Widget buildListOfGames() {
    return RefreshIndicator(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: listOfGames.length,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          itemBuilder: (BuildContext buildcontext, int index) {
            return InkWell(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250,
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              listOfGames[index].gamename,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              listOfGames[index].result1.substring(0, 3) +
                                  "-" +
                                  listOfGames[index].result1.substring(3, 4) +
                                  listOfGames[index].result2.substring(3, 4) +
                                  "-" +
                                  listOfGames[index].result2.substring(0, 3),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          displayMarketStatusWidget(
                              listOfGames[index].dayData,
                              listOfGames[index].holidayData,
                              listOfGames[index],
                              listOfGames[index].onoffstatus),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'OPEN: ${UtilityMethodsManager().beautifyTime(listOfGames[index].slot2Time1)}',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  'CLOSE: ${UtilityMethodsManager().beautifyTime(listOfGames[index].slot2Time2)}',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    listOfGames[index].onoffstatus
                        ? Material(
                            shape: CircleBorder(),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'images/play_button.png',
                                height: 70,
                                width: 70,
                              ),
                            ),
                            elevation: 5,
                          )
                        : Material(
                            shape: CircleBorder(),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'images/ic_play_button_grey.png',
                                height: 50,
                                width: 50,
                              ),
                            ),
                            elevation: 0,
                          ),
                  ],
                ),
              ),
              onTap: () {
                checkMarketStatus(listOfGames[index]);
              },
            );
          },
        ),
        onRefresh: _onRefresh);
  }

  void displayGames(Response response) {
    var responseJSON =
        AllGamesResponseModel.fromJson(json.decode(response.body));

    if (responseJSON.status) {
      if (mounted) {
        setState(() {
          _hasFetchedGames = true;
          listOfGames = responseJSON.data;
        });
      }
    } else {}
  }

  void fetchAuthToken() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    authToken = sharedPrefs.getString(Constants.SHARED_PREF_AUTH_TOKEN);
    setState(() {
      walletBalance =
          sharedPrefs.getString(Constants.SHARED_PREF_WALLET_BALANCE);
      supportNumber = sharedPrefs.getString(Constants.WHATSAPP);
    });

    setState(() {
      _showProgress = true;
    });

    HTTPService().fetchDetails().then((response) {
      if (response.statusCode == 200) {
        StarJackDetailsResponseModel responseModel =
            StarJackDetailsResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status) {
          String starlineName = responseModel.data.starname;
          String jackpotName = responseModel.data.jackname;
          SharedPreferences.getInstance().then((sharedPrefs) {
            sharedPrefs.setString(
                Constants.WHATSAPP, responseModel.data.whatsappno);
            sharedPrefs.setString(Constants.STARLINE_NAME, starlineName);
            sharedPrefs.setString(Constants.JACKPOT_NAME, jackpotName);
          });
          setState(() {
            supportNumber = responseModel.data.whatsappno;
          });
        } else {
          showErrorDialog(responseModel.message);
        }
      } else {
        showErrorDialog('Error occurred : Code ${response.statusCode}');
      }
    });

    HTTPService().getBanner(authToken).then((response) {
      if (response.statusCode == 200) {
        BannerResponseModel bannerResponseModel =
            BannerResponseModel.fromJson(json.decode(response.body));

        List<String> urlList = List();
        List<String> redirectUrlList = List();

        for (int i = 0; i < bannerResponseModel.data.length; i++) {
          urlList.add(bannerResponseModel.data[i].photo);
          redirectUrlList.add(bannerResponseModel.data[i].description);
        }

        setState(() {
          bannerUrl = urlList;
          redirectUrl = redirectUrlList;
        });
      } else {
        print('Could not fetch image');
      }
    });

    HTTPService().fetchAllGames(authToken).then((response) {
      if (mounted) {
        setState(() {
          _showProgress = false;
        });

        if (response.statusCode == 200) {
          displayGames(response);
        } else {
          showErrorDialog('Could not fetch data ${response.statusCode}');
        }
      }
    });

    HTTPService().getWalletDetails(authToken).then((response) => {
          if (response.statusCode == 200)
            {showWalletData(response)}
          else
            {print('Wallet balance could not be fetched')}
        });
  }

  void showWalletData(Response response) {
    var walletResponseJSON =
        GetWalletBalanceResponseModel.fromJson(json.decode(response.body));

    if (walletResponseJSON.status) {
      storeWalletBalance(walletResponseJSON.data.balance);
      if (mounted) {
        setState(() {
          _walletData = walletResponseJSON.data;
          walletBalance = _walletData.balance;
        });
      }
    } else {
      print(response.body);
    }
  }

  void storeWalletBalance(String walletBalance) async {
    int balance = int.parse(walletBalance);
    walletBalance = balance.toString();

    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(Constants.SHARED_PREF_WALLET_BALANCE, walletBalance);
  }

  Widget displayMarketStatusWidget(List<String> dayData,
      List<String> holidayData, GameData gameData, bool gameStatus) {
    if (gameStatus) {
      if ((UtilityMethodsManager().findDifference(gameData.slot2Time1) ||
              UtilityMethodsManager().findDifference(gameData.slot2Time2)) &&
          dayData.isNotEmpty &&
          dayData.contains(todayDay)) {
        if (holidayData.isEmpty || !holidayData.contains(todayDate)) {
          return Container(
            child: Text(
              'Market is open',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return Container(
            child: Text(
              'Market is closed',
              style: TextStyle(
                  color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          );
        }
      } else {
        return Container(
          child: Text(
            'Market is closed',
            style: TextStyle(
                color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        );
      }
    } else {
      return Container(
        child: Text(
          'Market is inactive',
          style: TextStyle(
              color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  void checkMarketStatus(GameData gameData) {
    if ((UtilityMethodsManager().findDifference(gameData.slot2Time1) ||
            UtilityMethodsManager().findDifference(gameData.slot2Time2)) &&
        gameData.dayData.isNotEmpty &&
        gameData.dayData.contains(todayDay)) {
      if (gameData.holidayData.isEmpty ||
          !gameData.holidayData.contains(todayDate)) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GameDashboard(
                  gameData: gameData,
                  isJackpot: false,
                  isStarline: false,
                  selectedJackpotTime: "",
                )));
      } else {
        showErrorDialog('Sorry! Market closed for the day');
      }
    } else {
      showErrorDialog('Sorry! Market closed for the day');
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

  void launchUrl() async {
    if (await canLaunch(redirectUrl[0]))
      await launch(redirectUrl[0]);
    else {
      print('Could not launch $redirectUrl');

      throw "Could not launch $redirectUrl";
    }
  }

  Future<void> _onRefresh() async {
    await HTTPService().fetchAllGames(authToken).then((response) {
      setState(() {
        _showProgress = false;
      });
      if (response.statusCode == 200) {
        displayGames(response);
      } else {
        showErrorDialog('Could not fetch data ${response.statusCode}');
      }
    });

    await HTTPService().getWalletDetails(authToken).then((response) => {
          if (response.statusCode == 200)
            {showWalletData(response)}
          else
            {print('Wallet balance could not be fetched')}
        });

    return;
  }

  Widget buildBannerWidgets() {
    for (int i = 0; i < bannerUrl.length; i++) {
      return InkWell(
        child: ClipRRect(
          child: Image.network(
            bannerUrl[i],
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        onTap: () {
          launchUrl();
        },
      );
    }
    return null;
  }
}
