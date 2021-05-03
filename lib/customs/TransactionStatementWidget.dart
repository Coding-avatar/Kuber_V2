import 'package:flutter/material.dart';

class TransactionStatementWidget extends StatelessWidget {
  final String particular;
  final String debitOrCredit;
  final String transactionAmount;
  final String transactionDate;
  final String transactionTime;
  final String transactionStatus;
  final String transactionMode;

  TransactionStatementWidget(
      {@required this.particular,
      @required this.debitOrCredit,
      @required this.transactionAmount,
      @required this.transactionDate,
      @required this.transactionTime,
      @required this.transactionStatus,
      @required this.transactionMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 270,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      child: Column(
        children: [
          Container(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Particular',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Text(
                  particular,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
              ],
            ),
          ),
          Divider(
            thickness: 0.2,
            color: Colors.grey,
          ),
          Container(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Debit/Credit',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Text(
                  debitOrCredit,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
              ],
            ),
          ),
          Divider(
            thickness: 0.2,
            color: Colors.grey,
          ),
          Container(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Withdraw Amount',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Text(
                  transactionAmount,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
              ],
            ),
          ),
          Divider(
            thickness: 0.2,
            color: Colors.grey,
          ),
          Container(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Transaction Date',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Text(
                  transactionDate,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
              ],
            ),
          ),
          Divider(
            thickness: 0.2,
            color: Colors.grey,
          ),
          Container(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Transaction Time',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Text(
                  transactionTime,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
              ],
            ),
          ),
          Divider(
            thickness: 0.2,
            color: Colors.grey,
          ),
          Container(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Transaction Status',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Text(
                  transactionStatus,
                  style: transactionStatus.toLowerCase() == 'approved'
                      ? TextStyle(color: Colors.green, fontSize: 16)
                      : TextStyle(color: Colors.red, fontSize: 16),
                )),
              ],
            ),
          ),
          Divider(
            thickness: 0.2,
            color: Colors.grey,
          ),
          Container(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Online/Offline',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Text(
                  transactionMode,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
              ],
            ),
          ),
          Divider(
            thickness: 0.2,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
