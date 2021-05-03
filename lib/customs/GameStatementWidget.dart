import 'package:flutter/material.dart';
import 'package:kuber_starline/customs/utility_methods.dart';

class GameStatementWidget extends StatelessWidget {
  final String marketName;
  final String particular;
  final String debitOrCredit;
  final String gameType;
  final String gameName;
  final String playPoint;
  final String playDate;
  final String playTime;
  final String digitPlayed;
  final String balance;

  GameStatementWidget(
      {@required this.marketName,
      @required this.particular,
      @required this.debitOrCredit,
      @required this.gameType,
      @required this.gameName,
      @required this.playPoint,
      @required this.playDate,
      @required this.playTime,
      @required this.digitPlayed,
      this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
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
                      'Market Name',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    marketName,
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
                    ),
                  ),
                ],
              ),
              height: 20,
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
                      'Game Name',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    gameName,
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
                      'Game Type',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    gameType,
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
                      'Play Point',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    playPoint,
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
                      'Play Date',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    playDate,
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
                      'Play Time',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    UtilityMethodsManager().beautifyTime(playTime),
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
                      'Digit',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    digitPlayed,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  )),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: Colors.grey,
            ),
            balance.isNotEmpty
                ? Container(
                    height: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Winning Amount',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            child: Text(
                          balance,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        )),
                      ],
                    ),
                  )
                : Container(),
            balance.isNotEmpty
                ? Divider(
                    thickness: 0.2,
                    color: Colors.grey,
                  )
                : Container(),
          ],
        ));
  }
}
