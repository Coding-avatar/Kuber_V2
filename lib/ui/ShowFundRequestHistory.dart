import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/TransactionStatementWidget.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/customs/transaction_type.dart';
import 'package:kuber_starline/customs/utility_methods.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/add_funds_request_history_response_data.dart';
import 'package:kuber_starline/network/models/add_funds_request_history_response_model.dart';
import 'package:kuber_starline/network/models/fund_withdraw_history_data.dart';
import 'package:kuber_starline/network/models/fund_withdraw_history_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowFundsRequestHistory extends StatefulWidget {
  final TransactionType transactionType;

  ShowFundsRequestHistory({@required this.transactionType});

  @override
  _ShowFundsRequestHistoryState createState() =>
      _ShowFundsRequestHistoryState();
}

class _ShowFundsRequestHistoryState extends State<ShowFundsRequestHistory> {
  TransactionType transactionType;

  bool _showProgress = false;
  String authToken = "";

  List<FundWithdrawHistoryData> fundWithdrawHistoryList = List();
  List<AddFundsHistoryResponseData> addFundsHistoryList = List();

  @override
  void initState() {
    super.initState();
    transactionType = widget.transactionType;

    fetchAuthToken();
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
                      transactionType == TransactionType.WITHDRAW
                          ? 'Fund Withdraw History'
                          : 'Fund Request History',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              ((transactionType == TransactionType.WITHDRAW &&
                          fundWithdrawHistoryList != null &&
                          fundWithdrawHistoryList.length > 0) ||
                      (transactionType == TransactionType.DEPOSIT) &&
                          addFundsHistoryList != null &&
                          addFundsHistoryList.length > 0)
                  ? Container(
                      margin: EdgeInsets.fromLTRB(5, 60, 5, 0),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount:
                              (transactionType == TransactionType.WITHDRAW)
                                  ? fundWithdrawHistoryList.length
                                  : addFundsHistoryList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (transactionType == TransactionType.WITHDRAW) {
                              FundWithdrawHistoryData historyData =
                                  fundWithdrawHistoryList[index];
                              return Container(
                                margin: EdgeInsets.all(8),
                                child: TransactionStatementWidget(
                                  particular: 'Withdraw',
                                  debitOrCredit: 'Debit',
                                  transactionAmount: historyData.transactionAmt,
                                  transactionDate: historyData.date,
                                  transactionMode: 'Online',
                                  transactionStatus: historyData.fundstatus,
                                  transactionTime: UtilityMethodsManager()
                                      .beautifyTime(historyData.time),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              );
                            } else {
                              AddFundsHistoryResponseData historyData =
                                  addFundsHistoryList[index];
                              return Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: TransactionStatementWidget(
                                  particular: 'Deposit',
                                  debitOrCredit: 'Credit',
                                  transactionAmount: historyData.transactionAmt,
                                  transactionDate: historyData.date,
                                  transactionMode: 'Online',
                                  transactionStatus: historyData.fundstatus,
                                  transactionTime: UtilityMethodsManager()
                                      .beautifyTime(historyData.time),
                                ),
                              );
                            }
                          }),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No data to show',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
              _showProgress
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(),
                      ),
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

  void fetchAuthToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);

    setState(() {
      _showProgress = true;
    });

    if (transactionType == TransactionType.WITHDRAW) {
      HTTPService().getFundWithdrawnHistory(authToken).then((response) {
        if (response.statusCode == 200) {
          updateListWithWithdrawnHistory(response);
        } else {
          showErrorDialog(
              context, 'Error fetching data ${response.statusCode}');
        }
      });
    } else {
      HTTPService().getAddFundsRequestHistory(authToken).then((response) {
        if (response.statusCode == 200) {
          updateListWithAddHistory(response);
        } else {
          showErrorDialog(
              context, 'Error fetching data ${response.statusCode}');
        }
      });
    }
  }

  void updateListWithWithdrawnHistory(Response response) {
    FundWithdrawHistoryResponse withdrawHistoryResponse =
        FundWithdrawHistoryResponse.fromJson(json.decode(response.body));

    setState(() {
      _showProgress = false;
    });

    if (withdrawHistoryResponse.status) {
      setState(() {
        fundWithdrawHistoryList = withdrawHistoryResponse.data;
      });
    }
  }

  void updateListWithAddHistory(Response response) {
    AddFundsRequestHistoryResponse addFundsRequestHistoryResponse =
        AddFundsRequestHistoryResponse.fromJson(json.decode(response.body));

    setState(() {
      _showProgress = false;
    });

    if (addFundsRequestHistoryResponse.status) {
      setState(() {
        addFundsHistoryList = addFundsRequestHistoryResponse.data;
      });
    }
  }

  void showErrorDialog(BuildContext buildContext, String message) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return CustomAlertDialog(
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            content: Container(
              width: 60,
              height: 170,
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
                        Icons.info_outline_rounded,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
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
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
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
                  ),
                ],
              ),
            ),
          );
        });
  }
}
