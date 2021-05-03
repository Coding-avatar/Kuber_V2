import 'package:flutter/material.dart';
import 'package:kuber_starline/ui/AddFundScreen.dart';
import 'package:kuber_starline/ui/DashboardScreen.dart';
import 'package:kuber_starline/ui/FundWithdrawScreen.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
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
                    'Wallet',
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
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 24,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.red,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Withdraw Funds',
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
                          builder: (context) => FundWithdrawScreen()));
                    },
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 24,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.green,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Add Funds',
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
                          builder: (context) => AddFundScreen()));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DashboardScreen()));
    return true;
  }
}
