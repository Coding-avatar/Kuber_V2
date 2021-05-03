import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/game_notice_data.dart';
import 'package:kuber_starline/network/models/game_notice_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeBoard extends StatefulWidget {
  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  String authToken = "";
  bool _showProgress = false;
  List<GameNoticeData> gameRuleList = List();

  String IMAGE_BASE = "https://brixhamtechnology.com/IMAGE_All";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAuthToken();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: true,
            elevation: 8,
            centerTitle: true,
            title: Text(
              'Notice Board',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            leading: InkWell(
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
              onTap: () {
                onBackPressed();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: new DecorationImage(
                          image: AssetImage(
                            'images/casino_bg.jpg',
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1), BlendMode.dstATop),
                        ),
                      ),
                    ),
                    (gameRuleList != null && gameRuleList.isNotEmpty)
                        ? Container(
                            height: MediaQuery.of(context).size.height,
                            margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                            child: ListView.builder(
                                itemCount: gameRuleList.length,
                                padding: EdgeInsets.all(2),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        gameRuleList[index].photo != null &&
                                                gameRuleList[index]
                                                    .photo
                                                    .isNotEmpty &&
                                                gameRuleList[index].photo !=
                                                    IMAGE_BASE
                                            ? Container(
                                                height: 120,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Image.network(
                                                  gameRuleList[index].photo,
                                                  fit: BoxFit.fill,
                                                ),
                                              )
                                            : Container(),
                                        Text(
                                          (gameRuleList != null &&
                                                  gameRuleList.isNotEmpty)
                                              ? gameRuleList[index].description
                                              : "",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          )
                        : Container(),
                    _showProgress
                        ? Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          )
                        : Container(),
                  ],
                )),
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();

    return true;
  }

  void getAuthToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);

    setState(() {
      _showProgress = true;
    });

    HTTPService().fetchNotice(authToken).then((response) => {
          if (response.statusCode == 200)
            {displayRuleList(response)}
          else
            {showErrorDialog(context, response.body)}
        });
  }

  displayRuleList(Response response) {
    GameNoticeResponse gameRuleResposne =
        GameNoticeResponse.fromJson(json.decode(response.body));

    setState(() {
      _showProgress = false;
      gameRuleList = gameRuleResposne.data;
    });
  }

  void showErrorDialog(BuildContext buildContext, String message) {
    setState(() {
      _showProgress = false;
    });

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
