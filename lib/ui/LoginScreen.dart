import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/login_response_model.dart';
import 'package:kuber_starline/ui/ForgotPasswordScreen.dart';
import 'package:kuber_starline/ui/RegisterScreen.dart';
import 'package:kuber_starline/ui/login_with_mpin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DashboardScreen.dart';
import 'ForgotUserId.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileController;
  TextEditingController passwordController;

  String mobile;
  String password;
  String fcm_token;

  bool _validMob = true;
  bool _validPassword = true;
  bool _showProgress = false;
  String supportNumber = "";

  @override
  void initState() {
    super.initState();
    mobileController = TextEditingController();
    passwordController = TextEditingController();

    mobile = "";
    password = "";

    getFCMToken();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mobileController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipRect(
              child: Image.asset('images/vector_wave_shape.png'),
            ),
            Positioned(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 120, 0, 0),
                child: RichText(
                  text: TextSpan(
                    text: 'Existing Users,\n',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'LOGIN TO \n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24)),
                      TextSpan(
                        text: 'EARN',
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
              margin: EdgeInsets.fromLTRB(20, 250, 20, 20),
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
                      'Whatsapp number:  $supportNumber',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Material(
                        child: TextField(
                          controller: mobileController,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "User ID",
                              errorText: _validMob
                                  ? null
                                  : "Please enter valid user id",
                              fillColor: Colors.white),
                          keyboardType: TextInputType.text,
                        ),
                        color: Colors.transparent,
                        shadowColor: Colors.black,
                        elevation: 20,
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Material(
                        child: TextField(
                          controller: passwordController,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Password",
                              errorText: _validPassword
                                  ? null
                                  : "Please enter valid password",
                              fillColor: Colors.white),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                        ),
                        color: Colors.transparent,
                        shadowColor: Colors.black,
                        elevation: 20,
                      )),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: !_showProgress
                        ? ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              onPressed: () {
                                mobile = mobileController.text.trim();
                                password = passwordController.text.trim();

                                if (mobile.isNotEmpty &&
                                    password.isNotEmpty &&
                                    password.length > 1) {
                                  setState(() {
                                    _showProgress = true;
                                  });

                                  HTTPService()
                                      .loginUser(
                                          mobile: mobile,
                                          password: password,
                                          fcmToken: fcm_token)
                                      .then((response) => {
                                            if (response.statusCode == 200)
                                              goToNextScreen(response)
                                            else
                                              showerrorDialog(response)
                                          });
                                } else {
                                  setState(() {
                                    if (mobile.isEmpty) _validMob = false;
                                    if (password.isEmpty)
                                      _validPassword = false;
                                  });
                                }
                              },
                              elevation: 12,
                              color: Colors.yellow,
                              splashColor: Colors.white,
                            ),
                          )
                        : CircularProgressIndicator(),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'OR',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'Login with MPIN',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginMPINScreen()));
                        },
                        elevation: 12,
                        color: Colors.red,
                        splashColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: InkWell(
                        child: RichText(
                          text: TextSpan(
                            text: 'Not registered yet?',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' Register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                        },
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 00, 0),
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .push(ScaleRoute(page: ForgotPasswordScreen()));
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 00, 0),
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Text(
                        'Forgot User Id?',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .push(ScaleRoute(page: ForgotUserIdScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      sharedPrefs.setString(Constants.SHARED_PREF_PASSWORD, password);

      sharedPrefs.setString(
          Constants.SHARED_PREF_AUTH_TOKEN, responseJSON.token);
      sharedPrefs.setBool(Constants.SHARED_PREF_REGISTRATION_COMPLETE, true);

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
      showerrorDialog(response);
    }
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

  showerrorDialog(Response response) {
    var responseJSON = LoginResponseModel.fromJson(json.decode(response.body));
    setState(() {
      _showProgress = false;
    });

    _showMyDialog(responseJSON.message);
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
