import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/how_to_play_data.dart';
import 'package:kuber_starline/network/models/how_to_play_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HowToPlayScreen extends StatefulWidget {
  @override
  _HowToPlayScreenState createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  String authToken = "";
  List<HowToPlayData> howToPlayData;
  bool _showProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAuthToken();
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
              'How To Play',
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
                  (howToPlayData != null && howToPlayData.isNotEmpty)
                      ? ListView.builder(
                          itemCount: howToPlayData.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text(
                                      howToPlayData[index].question,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  ),
                                  Container(
                                    child: Text(
                                      howToPlayData[index].answer,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  )
                                ],
                              ),
                            );
                          })
                      : Container(),
                  _showProgress
                      ? Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();

    return true;
  }

  void fetchAuthToken() async {
    setState(() {
      _showProgress = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);

    HTTPService().fetchHowToPlay(authToken).then((response) => {
          if (response.statusCode == 200)
            displayData(response)
          else
            {showErrorDialog(response.body)}
        });
  }

  displayData(Response response) {
    HowToPlayResponse howToPlayResponse =
        HowToPlayResponse.fromJson(json.decode(response.body));

    setState(() {
      _showProgress = false;
      howToPlayData = howToPlayResponse.data;
    });
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
}
