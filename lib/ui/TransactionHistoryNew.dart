import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/customs/utility_methods.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/transaction_history_response_data.dart';
import 'package:kuber_starline/network/models/transaction_history_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionHistoryScreenNew extends StatefulWidget {
  @override
  _TransactionHistoryScreenNewState createState() =>
      _TransactionHistoryScreenNewState();
}

class _TransactionHistoryScreenNewState
    extends State<TransactionHistoryScreenNew> {
  String authToken = "";
  String walletBalance = "";
  List<TransactionHistoryResponseData> listOfTransactionHistory = List();
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_AUTH_TOKEN);
      walletBalance =
          sharedPrefs.getString(Constants.SHARED_PREF_WALLET_BALANCE);

      _showProgress = true;
      HTTPService().fetchTransactionHistory(authToken).then((response) {
        setState(() {
          _showProgress = false;
        });
        if (response.statusCode == 200) {
          TransactionHistoryResponseModel responseModel =
              TransactionHistoryResponseModel.fromJson(
                  json.decode(response.body));

          if (responseModel.status) {
            setState(() {
              listOfTransactionHistory = responseModel.data;
            });
          } else {
            showErrorDialog(responseModel.message);
          }
        } else {
          showErrorDialog('Could not fetch data ${response.statusCode}');
        }
      });
    });
  }

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
                    'Transaction Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  child: _showProgress
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : listOfTransactionHistory == null ||
                              listOfTransactionHistory.isEmpty
                          ? Center(
                              child: Text(
                                'No data found',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            )
                          : SingleChildScrollView(
                              child: DataTable(
                                columnSpacing: 20,
                                horizontalMargin: 5,
                                dataRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                showBottomBorder: true,
                                headingTextStyle: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                dataTextStyle: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                columns: [
                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ))),
                                  DataColumn(
                                      label: Text('Amount',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ))),
                                  DataColumn(
                                      label: Text('Balance',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ))),
                                  DataColumn(
                                      label: Text('Comment',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ))),
                                ],
                                rows: listOfTransactionHistory.isEmpty
                                    ? []
                                    : listOfTransactionHistory // Loops through dataColumnText, each iteration assigning the value to element
                                        .map(
                                          ((element) => DataRow(
                                                cells: <DataCell>[
                                                  DataCell(Text(
                                                    UtilityMethodsManager()
                                                        .getDateFromString(
                                                            element.datetime
                                                                .substring(
                                                                    0, 10),
                                                            'yyyy-MM-dd'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  )),
                                                  //Extracting from Map element the value
                                                  DataCell(Text(
                                                    element.status
                                                                .toLowerCase() ==
                                                            'debit'
                                                        ? '- \u20B9${element.amount}'
                                                        : '+ \u20B9${element.amount}',
                                                    style: element.status
                                                                .toLowerCase() ==
                                                            'debit'
                                                        ? TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14)
                                                        : TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 14),
                                                  )),
                                                  DataCell(Text(
                                                    element.balance == null
                                                        ? '\u20B90'
                                                        : '\u20B9${element.balance.toString()}',
                                                    textAlign: TextAlign.center,
                                                  )),
                                                  DataCell(Text(element.comment
                                                      .toString())),
                                                ],
                                              )),
                                        )
                                        .toList(),
                              ),
                            )),
            ],
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void showErrorDialog(String message) {
    if (mounted) {
      showDialog(
          context: context,
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
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 40,
                          color: Colors.red,
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
