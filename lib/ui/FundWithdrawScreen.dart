import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/fund_request_response_model.dart';
import 'package:kuber_starline/network/models/get_wallet_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FundWithdrawScreen extends StatefulWidget {
  @override
  _FundWithdrawScreenState createState() => _FundWithdrawScreenState();
}

class _FundWithdrawScreenState extends State<FundWithdrawScreen> {
  String pointToRedeem = "";
  TextEditingController pointsController;
  String walletBalance = "";
  String authToken = "";

  bool _showProgress = false;
  String supportNumber = "";

  @override
  void initState() {
    super.initState();
    pointsController = TextEditingController();

    getWalletBalance();
  }

  @override
  void dispose() {
    super.dispose();
    pointsController.dispose();
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
                      'Withdraw Funds',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'images/ic_royal_sporty_logo.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'For Point Redeem Query Contact',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          supportNumber,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: 120,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                color: Colors.yellow,
                                width: 2,
                                style: BorderStyle.solid,
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '\u{20B9} $walletBalance',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: TextField(
                            controller: pointsController,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle:
                                    new TextStyle(color: Colors.grey[800]),
                                hintText: "Enter redeem point",
                                prefixIcon: Icon(
                                  Icons.account_balance_wallet_rounded,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                fillColor: Colors.white),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: _showProgress
                              ? CircularProgressIndicator()
                              : RaisedButton(
                                  onPressed: () {
                                    requestFund();
                                  },
                                  color: Colors.amber,
                                  elevation: 8,
                                  splashColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text("Send Redeem Request"),
                                ),
                        ),
                      ],
                    ),
                  ),
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

  void getWalletBalance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);
      walletBalance =
          sharedPreferences.getString(Constants.SHARED_PREF_WALLET_BALANCE);
      supportNumber = sharedPreferences.getString(Constants.WHATSAPP);
    });
  }

  void fetchWalletData() {
    HTTPService().getWalletDetails(authToken).then((response) {
      if (response.statusCode == 200) {
        GetWalletBalanceResponseModel walletResponseJSON =
            GetWalletBalanceResponseModel.fromJson(json.decode(response.body));

        if (walletResponseJSON.status) {
          SharedPreferences.getInstance().then((sharedPrefs) {
            sharedPrefs.setString(Constants.SHARED_PREF_WALLET_BALANCE,
                walletResponseJSON.data.balance);
          });

          if (mounted) {
            setState(() {
              walletBalance = walletResponseJSON.data.balance;
              _showProgress = false;
            });
          }
        } else {
          // showErrorDialog('Wallet data could not be fetched');
          print('Wallet data could not be fetched');
        }
      } else {
        print('Wallet data could not be fetched');
      }
    });
  }

  void requestFund() {
    pointToRedeem = pointsController.text.toString();
    if (pointToRedeem.isNotEmpty &&
        int.parse(pointToRedeem) < int.parse(walletBalance)) {
      setState(() {
        _showProgress = true;
      });

      HTTPService().requestFunds(authToken, pointToRedeem).then((response) {
        setState(() {
          _showProgress = false;
        });
        if (response.statusCode == 200) {
          FundRequestResponseModel responseModel =
              FundRequestResponseModel.fromJson(json.decode(response.body));

          if (responseModel.status) {
            pointsController.text = "";
            if (mounted) {
              // setState(() {
              //   walletBalance =
              //       (int.parse(walletBalance) - int.parse(pointToRedeem))
              //           .toString();
              // });
              showSuccessDialog(context, 'Amount requested to admin');
            }
            fetchWalletData();
          } else {
            showErrorDialog(responseModel.message);
          }
        } else {
          setState(() {
            _showProgress = false;
          });
          showErrorDialog('Request failed');
        }
      });
    } else {
      showErrorDialog('Please enter amount to redeem');
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
}
