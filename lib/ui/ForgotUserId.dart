import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/password_change_response_model.dart';

import 'LoginScreen.dart';

class ForgotUserIdScreen extends StatefulWidget {
  @override
  _ForgotUserIdScreenState createState() => _ForgotUserIdScreenState();
}

class _ForgotUserIdScreenState extends State<ForgotUserIdScreen> {
  TextEditingController mobileController;
  TextEditingController emailController;

  bool _showProgress = false;
  String mobile = "";
  String otp = '';

  @override
  void initState() {
    super.initState();
    mobileController = TextEditingController();
    emailController = TextEditingController();

    if (mobile.isNotEmpty) mobileController.text = mobile;
  }

  void dispose() {
    super.dispose();

    if (mobileController != null) mobileController.dispose();
    if (emailController != null) emailController.dispose();
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
                        'Forgot UserId',
                        style: TextStyle(color: Colors.black, fontSize: 26),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Container(
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
                                      prefixIcon:
                                          Icon(Icons.phone_android_rounded),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey[800]),
                                      hintText: "Mobile Number",
                                      fillColor: Colors.white70),
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  controller: mobileController,
                                ),
                              ),
                              SizedBox(
                                height: 10,
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
                                      prefixIcon:
                                          Icon(Icons.mail_outline_rounded),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey[800]),
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
                                          String mobile =
                                              mobileController.text.trim();
                                          String email =
                                              emailController.text.trim();
                                          if ((mobile != null &&
                                                  mobile.isNotEmpty &&
                                                  mobile.length == 10) &&
                                              email.isNotEmpty) {
                                            changeUserId();
                                          } else {
                                            if (mobile == null ||
                                                mobile.isEmpty) {
                                              showErrorDialog(
                                                  'Please enter mobile number');
                                            } else if (mobile.length != 10) {
                                              showErrorDialog(
                                                  'Invalid mobile number');
                                            } else if (email.isEmpty) {
                                              showErrorDialog(
                                                  'Please enter email address');
                                            }
                                          }
                                        },
                                        // color: Color(0xff6600CC),
                                        color: Colors.red,
                                        padding: EdgeInsets.all(12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "Proceed",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      )
                                    : CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: onBackPressed);
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
                height: 250,
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
                              emailController.dispose();
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

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void changeUserId() {
    String mobile = mobileController.text.trim();
    String emailid = emailController.text.trim();
    if (mobile.isNotEmpty || emailid.isNotEmpty) {
      setState(() {
        _showProgress = true;
      });

      HTTPService().forgotUserId(mobile, emailid).then((response) {
        setState(() {
          _showProgress = false;
        });

        if (response.statusCode == 200) {
          PasswordChangeResponseModel responseModel =
              PasswordChangeResponseModel.fromJson(json.decode(response.body));
          if (responseModel.status) {
            showSuccessDialog(context, responseModel.message);
          } else {
            showErrorDialog('User Id change failed');
          }
        } else {
          showErrorDialog('User Id change failed');
        }
      });
    } else {
      showErrorDialog('Please enter either mobile number or Email Id');
    }
  }
}
