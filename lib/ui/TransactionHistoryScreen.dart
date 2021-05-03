import 'package:flutter/material.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/customs/transaction_type.dart';
import 'package:kuber_starline/ui/ShowTransactionHistory.dart';

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
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
                      'Transaction History',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Card(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        elevation: 5,
                        color: Colors.white,
                        shadowColor: Colors.grey,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Image.asset(
                                    'images/ic_withdraw.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Withdraw History',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacement(ScaleRoute(
                                page: ShowTransactionHistory(
                                    transactionType:
                                        TransactionType.WITHDRAW)));
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
    Navigator.of(context).pop();

    return true;
  }
}
