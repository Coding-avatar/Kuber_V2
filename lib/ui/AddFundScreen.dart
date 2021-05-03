import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/add_point_request_model.dart';
import 'package:kuber_starline/network/models/create_order_response_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:url_launcher/url_launcher.dart';

class AddFundScreen extends StatefulWidget {
  @override
  _AddFundScreenState createState() => _AddFundScreenState();
}

class _AddFundScreenState extends State<AddFundScreen> {
  TextEditingController pointsController;
  String pointTodAdd = "";
  String walletBalance = "";
  String authToken = "";
  bool _showProgress = false;
  String supportNumber = "";

  // used for storing errors.
  String _upiAddrError;

  List<ApplicationMeta> upiApps = List();
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    getUserDetails();

    pointsController = TextEditingController();
    UpiPay.getInstalledUpiApplications().then((upiApps) {
      this.upiApps = upiApps;
    });

    // set up razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
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
                        'Add Funds',
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
                              height: 80,
                              width: 80,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Column(
                            children: [
                              Text(
                                'For Add Point Query Contact',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                supportNumber,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            width: 150,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.yellow,
                                  width: 1,
                                )),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    '\u{20B9}$walletBalance',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: pointsController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(30.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey[800]),
                                      hintText: "Enter Point",
                                      prefixIcon: Icon(
                                        Icons.account_balance_wallet_rounded,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      fillColor: Colors.white),
                                ),
                              ),
                              RawMaterialButton(
                                onPressed: () {
                                  pointTodAdd = pointsController.text.trim();
                                  if (pointTodAdd.isNotEmpty) {
                                    String number = '';
                                    SharedPreferences.getInstance()
                                        .then((sharedPrefs) {
                                      number =
                                          '+91${sharedPrefs.getString(Constants.WHATSAPP)}';
                                    });
                                    launch(
                                        "https://wa.me/$number?text=Please send Rs.$pointTodAdd");
                                  } else {
                                    showErrorDialog(
                                        'Point to add should be more than 0');
                                  }
                                },
                                elevation: 2.0,
                                fillColor: Colors.transparent,
                                child: Image.asset(
                                  'images/ic_whatsapp.png',
                                  height: 35,
                                  width: 35,
                                ),
                                padding: EdgeInsets.all(2.0),
                                shape: CircleBorder(),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 20, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  child: Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        '100',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      pointsController.text = '100';
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        '500',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      pointsController.text = '500';
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        '1000',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      pointsController.text = '1000';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 20, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  child: Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        '1500',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      pointsController.text = '1500';
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        '2000',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      pointsController.text = '2000';
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        '5000',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      pointsController.text = '5000';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            width: 200,
                            child: _showProgress
                                ? CircularProgressIndicator()
                                : RaisedButton(
                                    onPressed: () {
                                      // addFund();
                                      pointTodAdd =
                                          pointsController.text.trim();
                                      if (pointTodAdd.isNotEmpty &&
                                          int.parse(pointTodAdd) != 0) {
                                        choosePaymentDialog();
                                      } else {
                                        showErrorDialog('Please add a point');
                                      }
                                    },
                                    color: Colors.amber,
                                    elevation: 8,
                                    splashColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text("Add Points"),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  Future<void> _openUPIGateway(ApplicationMeta app) async {
    String merchantId = "";
    String upiAddress = "";
    if (app.upiApplication == UpiApplication.payTM) {
      merchantId = Constants.PAYTM_MERCHANT_ID;
      upiAddress = '8830232552@paytm';
    } else if (app.upiApplication == UpiApplication.googlePay) {
      merchantId = Constants.GOOGLE_PAY_MERCHANT_ID;
      upiAddress = 'apex111group@okicici';
    }

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");

    // this function will initiate UPI transaction.
    final a = await UpiPay.initiateTransaction(
      amount: pointTodAdd,
      app: app.upiApplication,
      receiverName: 'APEX INDUSTRIES',
      receiverUpiAddress: upiAddress,
      transactionRef: transactionRef,
      merchantCode: merchantId,
    );

    if (a.status == UpiTransactionStatus.success) {
      print(a.rawResponse);
      addFund();
    } else {
      showErrorDialog('UPI Transaction could not be completed');
    }
  }

  String _validateUpiAddress(String value) {
    if (value.isEmpty) {
      return 'UPI Address is required.';
    }

    if (!UpiPay.checkIfUpiAddressIsValid(value)) {
      return 'UPI Address is invalid.';
    }

    return null;
  }

  void getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);

    setState(() {
      walletBalance =
          sharedPreferences.getString(Constants.SHARED_PREF_WALLET_BALANCE);
      supportNumber = sharedPreferences.getString(Constants.WHATSAPP);
    });
  }

  void addFund() {
    pointTodAdd = pointsController.text.trim();

    if (pointTodAdd.isNotEmpty && int.parse(pointTodAdd) > 0) {
      setState(() {
        _showProgress = true;
      });

      HTTPService().addFunds(authToken, pointTodAdd).then((response) {
        if (response.statusCode == 200) {
          AddFundRequestModel responseModel =
              AddFundRequestModel.fromJson(json.decode(response.body));

          if (responseModel.status) {
            pointsController.text = "";

            setState(() {
              _showProgress = true;
            });

            showSuccessDialog(context, 'Amount requested to admin');
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

                              setState(() {
                                _showProgress = false;
                              });
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

  void showUPIPicker() {
    pointTodAdd = pointsController.text.trim();
    if (pointTodAdd.isNotEmpty) {
      String number = '';
      SharedPreferences.getInstance().then((sharedPrefs) {
        number = '+91${sharedPrefs.getString(Constants.WHATSAPP)}';
      });
      launch("https://wa.me/$number?text=Please send Rs.$pointTodAdd");
    } else {
      showErrorDialog('Point to add should be more than 0');
    }
  }

  void choosePaymentDialog() {
    /*if (mounted) {
      showDialog(
          context: context,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              content: Container(
                width: 50,
                height: 160,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        'Pay Via',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Image.asset(
                            'images/ic_whatsapp.png',
                            height: 50,
                            width: 50,
                            // color: Colors.red,
                          ),

                          */ /*onPressed: () {
                            Navigator.of(context).pop();
                          },*/ /*
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }*/
    showDialog(
        context: context,
        builder: (buildContext) {
          return CustomAlertDialog(
            contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            content: Container(
              width: 50,
              height: 140,
              //margin: EdgeInsets.fromLTRB(40, 40, 40, 40),
              decoration: new BoxDecoration(
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: Text(
                      'Share With',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Image.asset(
                              'images/ic_whatsapp.png',
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        onTap: () {
                          showUPIPicker();
                        },
                      )

                      /*InkWell(
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Image.asset(
                              'images/razorpay_logo.png',
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          payWithRazorPay();
                        },
                      ),*/
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print(
        'Order Id: ${response.orderId}, Transaction Id: ${response.paymentId}');
    addFund();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showErrorDialog('Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  void payWithRazorPay() {
    String orderId = "";
    int amount = int.parse(pointTodAdd) * 100;
    HTTPService().createRazorPayOrder(amount.toString()).then((response) {
      if (response.statusCode == 200) {
        CreateOrderResponseModel orderResponseModel =
            CreateOrderResponseModel.fromJson(json.decode(response.body));
        orderId = orderResponseModel.data.orderId;

        print('Amount : $amount');

        var options = {
          'key': 'rzp_test_3I7AP8iZHSVD2V',
          'amount': amount, //in the smallest currency sub-unit.
          'name': 'Royal Sporty',
          'order_id': orderId, // Generate order_id using Orders API
          'description': 'Royal Sporty',
          'timeout': 120, // in seconds
        };

        _razorpay.open(options);
      } else {
        print(response.body);
      }
    });
  }
}
