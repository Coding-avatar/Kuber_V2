import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/src/response.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/register_response_model.dart';
import 'package:kuber_starline/ui/DashboardScreen.dart';
import 'package:kuber_starline/ui/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name = "";
  String email = "";
  String mobileNumber = "";
  String fcm_token = "";
  String password = "";
  String username = "";

  bool isRegistering = false;
  bool _validName = true;
  bool _validEmail = true;
  bool _validMobile = true;
  bool _validPassword = true;
  bool _validUsername = true;
  bool _obscurePassword = true;

  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController mobileNumberController;
  TextEditingController usernameController;
  String supportNumber = "";

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    mobileNumberController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();

    getFCMToken();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    usernameController.dispose();
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
                Container(
                  margin: EdgeInsets.fromLTRB(20, 150, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      text: 'New Users,\n',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'REGISTER TO \n',
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
                Container(
                  margin: EdgeInsets.fromLTRB(20, 260, 20, 0),
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
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Material(
                            child: TextField(
                              controller: nameController,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(20.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.grey[800]),
                                  hintText: "Full name",
                                  errorText: _validName
                                      ? null
                                      : "Please enter valid name",
                                  fillColor: Colors.white),
                              keyboardType: TextInputType.name,
                            ),
                            color: Colors.transparent,
                            shadowColor: Colors.black,
                            elevation: 20,
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Material(
                            child: TextField(
                              controller: usernameController,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(20.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.grey[800]),
                                  hintText: "User ID",
                                  errorText: _validUsername
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
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Material(
                            child: TextField(
                              controller: emailController,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(20.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.grey[800]),
                                  hintText: "Email address",
                                  errorText: _validEmail
                                      ? null
                                      : "Please enter proper email address",
                                  fillColor: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            color: Colors.transparent,
                            shadowColor: Colors.black,
                            elevation: 20,
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
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
                                  hintStyle:
                                      new TextStyle(color: Colors.grey[800]),
                                  hintText: "Password",
                                  suffixIcon: IconButton(
                                    icon: _obscurePassword
                                        ? Icon(Icons.visibility_off_outlined)
                                        : Icon(Icons.visibility_outlined),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  errorText: _validPassword
                                      ? null
                                      : "Incorrect password format",
                                  fillColor: Colors.white),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscurePassword,
                            ),
                            color: Colors.transparent,
                            shadowColor: Colors.black,
                            elevation: 20,
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Material(
                            child: TextField(
                              controller: mobileNumberController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
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
                                  hintText: "Mobile Number",
                                  errorText: _validMobile
                                      ? null
                                      : "Please enter valid mobile number",
                                  fillColor: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                            color: Colors.transparent,
                            shadowColor: Colors.black,
                            elevation: 20,
                          )),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: !isRegistering
                            ? ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width,
                                height: 60.0,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  onPressed: () {
                                    if (nameController.text.trim().isNotEmpty &&
                                        emailController.text
                                            .trim()
                                            .isNotEmpty &&
                                        mobileNumberController.text
                                            .trim()
                                            .isNotEmpty &&
                                        mobileNumberController.text
                                                .trim()
                                                .length ==
                                            10) {
                                      setState(() {
                                        isRegistering = true;
                                      });

                                      email = emailController.text.trim();
                                      name = nameController.text.trim();
                                      mobileNumber =
                                          mobileNumberController.text.trim();
                                      password = passwordController.text.trim();
                                      username = usernameController.text.trim();

                                      HTTPService()
                                          .registerUser(
                                              email: email,
                                              name: name,
                                              mobile: mobileNumber,
                                              fcmtoken: fcm_token,
                                              password: password,
                                              username: username)
                                          .then((response) => {
                                                if (response.statusCode == 200)
                                                  {goToNextScreen(response)}
                                                else
                                                  {showerrorDialog(response)}
                                              });
                                    } else {
                                      if (nameController.text.isEmpty) {
                                        _validName = false;
                                      }

                                      if (emailController.text.isEmpty) {
                                        _validEmail = false;
                                      }

                                      if (mobileNumberController.text.isEmpty ||
                                          mobileNumberController.text.length !=
                                              10) {
                                        _validMobile = false;
                                      }
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
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: InkWell(
                            child: RichText(
                              text: TextSpan(
                                text: 'Already a player?',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' Login',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 16)),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                          )),
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

  goToNextScreen(Response response) async {
    var responseJSON = RegisterResponse.fromJson(json.decode(response.body));

    setState(() {
      isRegistering = false;
    });

    if (responseJSON.status == true) {
      final sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setString(Constants.SHARED_PREF_NAME, name);
      sharedPrefs.setString(Constants.SHARED_PREF_EMAIL, email);
      sharedPrefs.setString(Constants.SHARED_PREF_MOBILE_NUMBER, mobileNumber);
      sharedPrefs.setString(Constants.SHARED_PREF_USER_NAME, username);
      sharedPrefs.setString(
          Constants.SHARED_PREF_PASSWORD, responseJSON.password);
      sharedPrefs.setString(
          Constants.SHARED_PREF_AUTH_TOKEN, responseJSON.token);
      sharedPrefs.setBool(Constants.SHARED_PREF_REGISTRATION_COMPLETE, true);

      Navigator.of(context).pushAndRemoveUntil(
          ScaleRoute(page: DashboardScreen()), (route) => false);
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
    var responseJSON = RegisterResponse.fromJson(json.decode(response.body));
    setState(() {
      isRegistering = false;
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
