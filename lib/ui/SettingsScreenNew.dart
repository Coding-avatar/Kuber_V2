import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/network/models/password_change_response_model.dart';
import 'package:kuber_starline/ui/DashboardScreen.dart';
import 'package:kuber_starline/ui/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreenNew extends StatefulWidget {
  @override
  _SettingsScreenNewState createState() => _SettingsScreenNewState();
}

class _SettingsScreenNewState extends State<SettingsScreenNew> {
  String email = "";
  String mobile = "";
  String name = "";
  String authToken = "";
  String currentPassword = "";

  bool _shouldLogOutUser = false;
  bool _showNotifications = true;

  TextEditingController mobileNumberController;
  TextEditingController oldPasswordController;
  TextEditingController newPasswordController;
  TextEditingController confirmPasswordController;
  bool _showPasswordBox = false;
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();

    fetchUserDetails();

    mobileNumberController = TextEditingController();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    mobileNumberController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
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
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 26,
                    ),
                    onTap: () {
                      onBackPressed();
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'User Settings',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.account_circle_rounded,
                                  color: Colors.black54,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'Name : ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.mail_outline_rounded,
                                  color: Colors.black54,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'User Email : ',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  email,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        child: Container(
                            height: 50,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone_android_rounded,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Mobile number:',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  mobile,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ],
                            )),
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext buildContext) {
                                return CustomAlertDialog(
                                  content: SingleChildScrollView(
                                    child: Container(
                                      height: 200,
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.phone_android_rounded,
                                            size: 40.0,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextField(
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                            controller: mobileNumberController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                            decoration: new InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    const Radius.circular(20.0),
                                                  ),
                                                ),
                                                filled: true,
                                                hintStyle: new TextStyle(
                                                    color: Colors.grey[800]),
                                                hintText:
                                                    "Enter new mobile number",
                                                fillColor: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                if (mobileNumberController
                                                        .text.isNotEmpty &&
                                                    mobileNumberController
                                                            .text.length ==
                                                        10) {
                                                  String newMobile =
                                                      mobileNumberController
                                                          .text
                                                          .trim();
                                                  if (newMobile != null &&
                                                      newMobile.length == 10) {
                                                    HTTPService()
                                                        .changeMobileNumber(
                                                            authToken,
                                                            newMobile)
                                                        .then((response) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (response.statusCode ==
                                                          200) {
                                                        showSuccessDialog(
                                                            context,
                                                            'Mobile number changed successfully');
                                                      } else {
                                                        showErrorDialog(
                                                            'Server error occurred! Error code ${response.statusCode}');
                                                      }
                                                    });
                                                  } else {
                                                    Navigator.of(context).pop();
                                                    showErrorDialog(
                                                        'Please enter valid mobile number');
                                                  }
                                                }
                                              },
                                              child: Text(
                                                'Change',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 20,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Change Password',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          // showChangePasswordDialog();
                          print('Old Password : $_showOldPassword');
                          print('New Password : $_showNewPassword');
                          print('Confirm Password : $_showConfirmPassword');

                          setState(() {
                            _showPasswordBox = !_showPasswordBox;
                          });
                        },
                      ),
                      _showPasswordBox
                          ? Container(
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    height: 50,
                                    width: 200,
                                    child: TextField(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      textAlign: TextAlign.center,
                                      controller: oldPasswordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: !_showOldPassword,
                                      decoration: new InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(12.0),
                                            ),
                                          ),
                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.grey[800]),
                                          hintText: "Old Password",
                                          fillColor: Colors.white,
                                          suffixIcon: IconButton(
                                              icon: _showOldPassword
                                                  ? Icon(
                                                      Icons.visibility,
                                                      color: Colors.black,
                                                    )
                                                  : Icon(
                                                      Icons.visibility_off,
                                                      color: Colors.black,
                                                    ),
                                              onPressed: () {
                                                setState(() {
                                                  if (_showOldPassword ==
                                                      false) {
                                                    _showOldPassword = true;
                                                  } else {
                                                    _showOldPassword = false;
                                                  }
                                                });
                                              })),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 200,
                                    height: 50,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: TextField(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      textAlign: TextAlign.center,
                                      controller: newPasswordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: !_showNewPassword,
                                      decoration: new InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(12.0),
                                            ),
                                          ),
                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.grey[800]),
                                          hintText: "New Password",
                                          fillColor: Colors.white,
                                          suffixIcon: IconButton(
                                              icon: _showNewPassword
                                                  ? Icon(
                                                      Icons.visibility,
                                                      color: Colors.black,
                                                    )
                                                  : Icon(
                                                      Icons.visibility_off,
                                                      color: Colors.black,
                                                    ),
                                              onPressed: () {
                                                setState(() {
                                                  if (_showNewPassword) {
                                                    _showNewPassword = false;
                                                  } else {
                                                    _showNewPassword = true;
                                                  }
                                                });
                                              })),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 200,
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextField(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      textAlign: TextAlign.center,
                                      controller: confirmPasswordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: !_showConfirmPassword,
                                      decoration: new InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(12.0),
                                            ),
                                          ),
                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.grey[800]),
                                          hintText: "Confirm Password",
                                          fillColor: Colors.white,
                                          suffixIcon: IconButton(
                                              icon: _showConfirmPassword
                                                  ? Icon(
                                                      Icons.visibility,
                                                      color: Colors.black,
                                                    )
                                                  : Icon(
                                                      Icons.visibility_off,
                                                      color: Colors.black,
                                                    ),
                                              onPressed: () {
                                                setState(() {
                                                  if (_showConfirmPassword) {
                                                    _showConfirmPassword =
                                                        false;
                                                  } else {
                                                    _showConfirmPassword = true;
                                                  }
                                                });
                                              })),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          currentPassword =
                                              oldPasswordController.text.trim();
                                          String newPassword =
                                              newPasswordController.text.trim();
                                          String confirmPassword =
                                              confirmPasswordController.text
                                                  .trim();

                                          if (currentPassword != null &&
                                              currentPassword.isNotEmpty &&
                                              newPassword != null &&
                                              newPassword.isNotEmpty &&
                                              confirmPassword != null &&
                                              confirmPassword.isNotEmpty &&
                                              newPassword == confirmPassword) {
                                            HTTPService()
                                                .changePassword(
                                                    authToken, newPassword)
                                                .then((response) {
                                              if (response.statusCode == 200) {
                                                var responseJSON =
                                                    PasswordChangeResponseModel
                                                        .fromJson(json.decode(
                                                            response.body));
                                                if (responseJSON.status) {
                                                  _shouldLogOutUser = true;

                                                  showSuccessDialog(context,
                                                      'Password changed successfully. Please log in again!');
                                                } else {
                                                  showErrorDialog(
                                                      responseJSON.message);
                                                }
                                              } else {
                                                showErrorDialog(
                                                    'Server error! Error code ${response.statusCode}');
                                              }
                                            });
                                          } else {
                                            if (currentPassword == null ||
                                                currentPassword.isEmpty)
                                              showErrorDialog(
                                                  'Please enter your current password!');
                                            else if (newPassword == null ||
                                                newPassword.isEmpty)
                                              showErrorDialog(
                                                  'Please enter new password!');
                                            else if (confirmPassword == null ||
                                                confirmPassword.isEmpty)
                                              showErrorDialog(
                                                  'Please confirm new password!');
                                            else if (newPassword !=
                                                confirmPassword)
                                              showErrorDialog(
                                                  'New password is not same as confirm password');
                                          }
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Show Notifications',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Switch(
                              value: _showNotifications,
                              onChanged: (value) {
                                setState(() {
                                  _showNotifications = value;
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pushReplacement(ScaleRoute(page: DashboardScreen()));
    return true;
  }

  void fetchUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      email = sharedPreferences.getString(Constants.SHARED_PREF_EMAIL);
      mobile = sharedPreferences.getString(Constants.SHARED_PREF_MOBILE_NUMBER);
      name = sharedPreferences.getString(Constants.SHARED_PREF_NAME);
      authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);
      currentPassword =
          sharedPreferences.getString(Constants.SHARED_PREF_PASSWORD);

      // if (currentPassword != null && currentPassword.isNotEmpty)
      //   currentPassword = currentPassword.replaceAll(RegExp(r"."), "*");

      oldPasswordController.text = currentPassword;
    });
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
                height: 200,
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
                              if (_shouldLogOutUser) logoutUser();
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  void showErrorDialog(String message) {
    if (mounted) {
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

  void logoutUser() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String supportNumber = sharedPrefs.getString(Constants.WHATSAPP);
    sharedPrefs.clear();
    sharedPrefs.setString(Constants.WHATSAPP, supportNumber);

    Navigator.of(context)
        .pushAndRemoveUntil(ScaleRoute(page: LoginScreen()), (route) => false);
  }
}
