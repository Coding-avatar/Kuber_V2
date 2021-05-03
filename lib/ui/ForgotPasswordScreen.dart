import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/src/response.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/forgot_password_response_model.dart';
import 'package:kuber_starline/network/models/password_change_response_model.dart';
import 'package:kuber_starline/ui/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  TextEditingController mobileController;
  TextEditingController emailController;
  TextEditingController newPasswordController;
  TextEditingController confirmPasswordController;
  AnimationController _controller;

  bool _showProgress = false;
  Timer timer;

  /*
    pagerState: 0 - do not show otp fields
    pagerState: 1 - show otp fields
   */
  int pagerState = 0;

  String mobile = "";
  String otp = '';

  @override
  void initState() {
    super.initState();
    mobileController = TextEditingController();
    emailController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 30),
    );

    if (pagerState == 1) {
      _controller.forward();
      startTimer();
    }

    if (mobile.isNotEmpty) mobileController.text = mobile;
  }

  @override
  void dispose() {
    super.dispose();

    if (mobileController != null) mobileController.dispose();
    if (emailController != null) emailController.dispose();
    if (newPasswordController != null) newPasswordController.dispose();
    if (confirmPasswordController != null) confirmPasswordController.dispose();

    if (_controller != null) _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  ClipRect(
                    child: Image.asset('images/vector_wave_shape.png'),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(color: Colors.black, fontSize: 26),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: pagerState == 0
                          ? showMobileNumberField()
                          : showNewPasswordField(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: onBackPressed);
  }

  Widget showMobileNumberField() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
            child: TextField(
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(Icons.phone_android_rounded),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "Mobile Number",
                  fillColor: Colors.white70),
              keyboardType: TextInputType.number,
              maxLines: 1,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              controller: mobileController,
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          // Container(
          //   alignment: Alignment.center,
          //   child: Text(
          //     'OR',
          //     style: TextStyle(color: Colors.black87, fontSize: 20),
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: TextField(
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "Email Address",
                  fillColor: Colors.white70),
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              controller: emailController,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
            alignment: Alignment.center,
            child: !_showProgress
                ? RaisedButton(
                    onPressed: () {
                      String mobile = mobileController.text.trim();
                      String email = emailController.text.trim();

                      if (mobile != null &&
                          mobile.isNotEmpty &&
                          mobile.length == 10 &&
                          email.isNotEmpty) {
                        setState(() {
                          if (pagerState == 0)
                            pagerState = 1;
                          else
                            pagerState = 0;
                        });
                      } else {
                        if (mobile == null || mobile.isEmpty)
                          showErrorDialog('Please enter mobile number');
                        else if (mobile.length != 10)
                          showErrorDialog('Invalid mobile number');
                        else if (email.isEmpty)
                          showErrorDialog('Please enter Email Id');
                      }
                    },
                    // color: Color(0xff6600CC),
                    color: Colors.red,
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Proceed",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget showNewPasswordField() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
            child: TextField(
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "New Password",
                  fillColor: Colors.white70),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              maxLines: 1,
              controller: newPasswordController,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
            child: TextField(
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "Confirm Password",
                  fillColor: Colors.white70),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              maxLines: 1,
              controller: confirmPasswordController,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
            alignment: Alignment.center,
            child: !_showProgress
                ? RaisedButton(
                    onPressed: () {
                      changePassword();
                    },
                    // color: Color(0xff6600CC),
                    color: Colors.red,
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Change Password",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : CircularProgressIndicator(),
          ),
        ],
      ),
    );
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
                height: 300,
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

                              _controller.dispose();
                              mobileController.dispose();
                              Navigator.of(context).pushAndRemoveUntil(
                                  ScaleRoute(page: LoginScreen()),
                                  (route) => false);
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

  void startTimer() {
    timer = Timer(Duration(seconds: 30), () {
      setState(() {
        _showProgress = false;
        pagerState = 0;

        _controller.dispose();
        _controller = new AnimationController(
          vsync: this,
          duration: new Duration(seconds: 30),
        );
      });
    });
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void savePassword(Response response) async {
    ForgotPasswordResponseModel responseModel =
        ForgotPasswordResponseModel.fromJson(json.decode(response.body));

    SharedPreferences.getInstance().then((sharedPrefs) {
      sharedPrefs.setString(
          Constants.SHARED_PREF_PASSWORD, responseModel.data.password);
    });
  }

  void changePassword() {
    String password = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String email = emailController.text.trim();
    if (password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword) {
      setState(() {
        _showProgress = true;
      });

      HTTPService().changePasswordNew(password, mobile, email).then((response) {
        if (response.statusCode == 200) {
          PasswordChangeResponseModel responseModel =
              PasswordChangeResponseModel.fromJson(json.decode(response.body));
          if (responseModel.status) {
            showSuccessDialog(context, responseModel.message);
          } else {
            showErrorDialog('Password change failed');
          }
        } else {
          showErrorDialog('Password change failed');
        }
      });
    } else {}
  }
}
