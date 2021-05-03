import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DashboardScreen.dart';

class LoginMPINScreen extends StatefulWidget {
  @override
  _LoginMPINScreenState createState() => _LoginMPINScreenState();
}

class _LoginMPINScreenState extends State<LoginMPINScreen> {
  TextEditingController mpinController;
  bool _validPIN = true;
  bool _showProgress = false;
  String fcm_token = "";
  String supportNumber = "";

  @override
  void initState() {
    super.initState();
    mpinController = TextEditingController();
    getFCMToken();
  }

  @override
  void dispose() {
    super.dispose();
    mpinController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                ClipRect(
                  child: Image.asset('images/vector_wave_shape.png'),
                ),
                Positioned(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 140, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Existing Users,\n',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'LOGIN With\n',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 24)),
                          TextSpan(
                            text: 'MPIN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                  top: 40,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 270, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'Email id: randomemail@gmail.com',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Whatsapp number: $supportNumber',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Material(
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: mpinController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(20.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.grey[800]),
                                  hintText: "Enter 4 digit MPIN",
                                  errorText: _validPIN
                                      ? null
                                      : "Please enter valid 4 digit number",
                                  fillColor: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                            color: Colors.transparent,
                            shadowColor: Colors.black,
                            elevation: 20,
                          )),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
                        child: !_showProgress
                            ? ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width,
                                height: 50.0,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    'Login with MPIN',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showProgress = true;
                                    });

                                    loginUser();
                                  },
                                  elevation: 12,
                                  color: Colors.yellow,
                                  splashColor: Colors.white,
                                ),
                              )
                            : CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();

    return true;
  }

  void loginUser() {
    if (mpinController.text.isNotEmpty && mpinController.text.length == 4) {
      String mpin = mpinController.text.trim();
      getDeviceIMEI().then((imeiList) => HTTPService()
          .loginUserWithMPIN(imei: imeiList[0], mpin: mpin, fcmToken: fcm_token)
          .then((response) => {
                if (response.statusCode == 200)
                  {goToNextScreen(response)}
                else
                  {showerrorDialog(response)}
              }));
    }
  }

  Future<List<String>> getDeviceIMEI() async {
    List<String> deviceimei = List();
    try {
      deviceimei = await ImeiPlugin.getImeiMulti(
          shouldShowRequestPermissionRationale: false);
    } on PlatformException {
      print('Failed to get platform version');
    }

    return deviceimei;
  }

  goToNextScreen(Response response) async {
    var responseJSON = LoginResponseModel.fromJson(json.decode(response.body));
    setState(() {
      _showProgress = false;
    });

    if (responseJSON.status == true) {
      final sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setString(Constants.SHARED_PREF_NAME, responseJSON.name);
      sharedPrefs.setString(Constants.SHARED_PREF_EMAIL, responseJSON.email);
      sharedPrefs.setString(
          Constants.SHARED_PREF_MOBILE_NUMBER, responseJSON.mobile);
      sharedPrefs.setString(
          Constants.SHARED_PREF_USER_NAME, responseJSON.username);
      sharedPrefs.setString(
          Constants.SHARED_PREF_AUTH_TOKEN, responseJSON.token);
      sharedPrefs.setBool(Constants.SHARED_PREF_REGISTRATION_COMPLETE, true);

      Navigator.of(context).pushAndRemoveUntil(
          ScaleRoute(page: DashboardScreen()), (route) => false);
    } else {
      showerrorDialog(response);
    }
  }

  showerrorDialog(Response response) {
    var responseJSON = LoginResponseModel.fromJson(json.decode(response.body));
    setState(() {
      _showProgress = false;
    });

    _showMyDialog(responseJSON.message);
  }

  Future<void> _showMyDialog(String contentMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.info,
            color: Color(0xFFFF4c4c),
            size: 40,
          ),
          content: Text(
            contentMessage,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Montserrat'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getFCMToken() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      fcm_token = sharedPrefs.getString(Constants.SHARED_PREF_FCM_TOKEN);

      setState(() {
        supportNumber = sharedPrefs.getString(Constants.WHATSAPP);
      });
    });
  }
}
