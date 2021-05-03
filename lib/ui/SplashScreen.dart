import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/starjackdetails_response_model.dart';
import 'package:kuber_starline/ui/DashboardScreen.dart';
import 'package:kuber_starline/ui/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    HTTPService().fetchDetails().then((response) {
      if (response.statusCode == 200) {
        StarJackDetailsResponseModel responseModel =
            StarJackDetailsResponseModel.fromJson(json.decode(response.body));
        if (responseModel.status) {
          String starlineName = responseModel.data.starname;
          String jackpotName = responseModel.data.jackname;
          String supportNumber = responseModel.data.whatsappno;
          SharedPreferences.getInstance().then((sharedPrefs) {
            sharedPrefs.setString(Constants.WHATSAPP, supportNumber);
            sharedPrefs.setString(Constants.STARLINE_NAME, starlineName);
            sharedPrefs.setString(Constants.JACKPOT_NAME, jackpotName);
          });
        } else {}
      } else {}
    });
    Timer(Duration(milliseconds: 2000), () => {getLoggedInStatus()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            alignment: Alignment.center,
            child: Image.asset(
              'images/ic_royal_sporty_logo.png',
              height: 200,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }

  void getLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn =
        prefs.getBool(Constants.SHARED_PREF_REGISTRATION_COMPLETE);

    if (isLoggedIn != null && isLoggedIn) {
      Navigator.of(context).pushReplacement(new PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ));
    } else {
      Navigator.of(context).pushReplacement(new PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ));
    }
  }
}
