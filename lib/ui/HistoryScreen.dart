import 'package:flutter/material.dart';
import 'package:kuber_starline/customs/history_type.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/ui/DashboardScreen.dart';
import 'package:kuber_starline/ui/FundRequestHistoryScreen.dart';
import 'package:kuber_starline/ui/TransactionHistoryScreen.dart';

import 'PlayingHistoryScreen.dart';
import 'TransactionHistoryNew.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
                      'History',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        elevation: 5,
                        color: Colors.white,
                        shadowColor: Colors.grey,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Image.asset(
                                    'images/ic_history.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Playing History',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(ScaleRoute(
                                page: PlayingHistoryScreen(
                              historyType: HistoryType.Playing,
                              isJackPot: false,
                              isStarline: false,
                            )));
                          },
                        )),
                    Card(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        elevation: 5,
                        color: Colors.white,
                        shadowColor: Colors.grey,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Image.asset(
                                    'images/ic_winning.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Winning History',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(ScaleRoute(
                                page: PlayingHistoryScreen(
                              historyType: HistoryType.Winning,
                              isStarline: false,
                              isJackPot: false,
                            )));
                          },
                        )),
                    Card(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        elevation: 5,
                        color: Colors.white,
                        shadowColor: Colors.grey,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Image.asset(
                                    'images/ic_transaction.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Transaction History',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    TransactionHistoryScreenNew()));
                          },
                        )),
                    Card(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        elevation: 5,
                        color: Colors.white,
                        shadowColor: Colors.grey,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Image.asset(
                                    'images/ic_money_bag.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Fund Request History',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    FundRequestHistoryScreen()));
                          },
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DashboardScreen()));

    return true;
  }
}
