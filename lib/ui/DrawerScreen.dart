import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/src/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/scale_route_transition.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/ui/GameRateScreen.dart';
import 'package:kuber_starline/ui/HowToPlayScreen.dart';
import 'package:kuber_starline/ui/LoginScreen.dart';
import 'package:kuber_starline/ui/NoticeBoard.dart';
import 'package:kuber_starline/ui/ProfileScreen.dart';
import 'package:kuber_starline/ui/SettingsScreenNew.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HistoryScreen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String name;
  String email;
  String mobileNumber;

  String authToken;
  File imageFile;
  PackageInfo packageInfo;
  String versionNumber;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    PackageInfo.fromPlatform().then((packageInfo) {
      this.packageInfo = packageInfo;
      setState(() {
        versionNumber = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: imageFile == null
                        ? CircleAvatar(
                            backgroundImage:
                                AssetImage('images/default_user.png'),
                            backgroundColor: Colors.white,
                            radius: 32,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image.file(
                              imageFile,
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                    onTap: () {
                      showImagePickerDialog();
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name == null ? "" : name,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        mobileNumber == null ? "" : mobileNumber,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'App version : $versionNumber',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          // Row(
          //   children: [
          //     RawMaterialButton(
          //       onPressed: () {},
          //       elevation: 2.0,
          //       fillColor: Colors.red,
          //       child: Icon(
          //         Icons.refresh_outlined,
          //         size: 24.0,
          //         color: Colors.white,
          //       ),
          //       padding: EdgeInsets.all(8.0),
          //       shape: CircleBorder(),
          //     ),
          //     Text(
          //       'Refresh',
          //       style: TextStyle(color: Colors.black, fontSize: 18),
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: 12,
          // ),
          InkWell(
            child: Row(
              children: [
                RawMaterialButton(
                  onPressed: () {},
                  elevation: 2.0,
                  fillColor: Colors.lightGreen,
                  child: Icon(
                    Icons.account_circle_rounded,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(),
                ),
                Text(
                  'My Profile',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          SizedBox(
            height: 12,
          ),
          InkWell(
            child: Row(
              children: [
                RawMaterialButton(
                  onPressed: () {},
                  elevation: 2.0,
                  fillColor: Colors.deepOrangeAccent,
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(),
                ),
                Text(
                  'Generate MPIN',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
            onTap: () {
              showMPINDialog();
            },
          ),
          SizedBox(
            height: 12,
          ),
          InkWell(
            child: Row(
              children: [
                RawMaterialButton(
                  onPressed: () {},
                  elevation: 2.0,
                  fillColor: Colors.purple,
                  child: Icon(
                    Icons.history_rounded,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(),
                ),
                Text(
                  'My History',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HistoryScreen()));
            },
          ),
          SizedBox(
            height: 12,
          ),
          InkWell(
            child: Row(
              children: [
                RawMaterialButton(
                  onPressed: () {},
                  elevation: 2.0,
                  fillColor: Colors.deepPurple,
                  child: Icon(
                    Icons.history_rounded,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(),
                ),
                Text(
                  'Game Rates',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GameRateScreen()));
            },
          ),
          SizedBox(
            height: 12,
          ),
          InkWell(
            child: Row(
              children: [
                RawMaterialButton(
                  onPressed: () {},
                  elevation: 2.0,
                  fillColor: Colors.lightGreen,
                  child: Image.asset(
                    'images/ic_rules.png',
                    height: 24,
                    width: 24,
                  ),
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(),
                ),
                Text(
                  'Notice Board',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NoticeBoard()));
            },
          ),
          SizedBox(
            height: 12,
          ),
          InkWell(
            child: Row(
              children: [
                RawMaterialButton(
                  onPressed: () {},
                  elevation: 2.0,
                  fillColor: Colors.lightGreen,
                  child: Icon(
                    Icons.info_outlined,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(),
                ),
                Text(
                  'How to play',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HowToPlayScreen()));
            },
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              RawMaterialButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacement(ScaleRoute(page: SettingsScreenNew()));
                },
                elevation: 2.0,
                fillColor: Colors.blueAccent,
                child: Icon(
                  Icons.settings,
                  size: 24.0,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(8.0),
                shape: CircleBorder(),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacement(ScaleRoute(page: SettingsScreenNew()));
                },
                child: Text(
                  'Settings',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              RawMaterialButton(
                onPressed: () {
                  logoutUser();
                },
                elevation: 2.0,
                fillColor: Colors.lightBlueAccent,
                child: Icon(
                  Icons.logout,
                  size: 24.0,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(8.0),
                shape: CircleBorder(),
              ),
              InkWell(
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                onTap: () {
                  logoutUser();
                },
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  void logoutUser() {
    showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Are you sure you want to log out?',
            ),
            actions: [
              MaterialButton(
                shape: RoundedRectangleBorder(),
                splashColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                elevation: 5,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(),
                splashColor: Colors.white,
                onPressed: () {
                  SharedPreferences.getInstance().then((sharedPrefs) {
                    String supportNumber =
                        sharedPrefs.getString(Constants.WHATSAPP);
                    sharedPrefs.clear();
                    sharedPrefs.setString(Constants.WHATSAPP, supportNumber);
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                      ScaleRoute(page: LoginScreen()), (route) => false);
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                elevation: 5,
              )
            ],
          );
        });
  }

  void fetchUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPreferences.getString(Constants.SHARED_PREF_NAME);
      mobileNumber =
          sharedPreferences.getString(Constants.SHARED_PREF_MOBILE_NUMBER);
      email = sharedPreferences.getString(Constants.SHARED_PREF_EMAIL);
      authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);

      String imagePath =
          sharedPreferences.getString(Constants.SHARED_PREF_USER_DP_PATH);
      if (imagePath != null) imageFile = File(imagePath);
    });
  }

  void showMPINDialog() {
    TextEditingController mpinController = new TextEditingController();

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
                      Icons.lock_outline_rounded,
                      size: 40.0,
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: mpinController,
                      keyboardType: TextInputType.number,
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
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Enter 4 digit Mpin",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (mpinController.text.isNotEmpty &&
                              mpinController.text.length == 4) {
                            String mpin = mpinController.text.trim();
                            getDeviceIMEI().then((imeiList) => {
                                  HTTPService()
                                      .generateMpin(
                                          authToken, mpin, imeiList[0])
                                      .then((response) => {
                                            showMPINGeneratedDialog(
                                                context, response)
                                          })
                                });
                          }
                        },
                        child: Text(
                          'Generate MPIN',
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

  showMPINGeneratedDialog(BuildContext buildContext, Response response) {
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
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
                          'MPIN generated successfully',
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
                              Navigator.of(buildContext).pop();
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
    } else {
      showDialog(
          context: context,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              content: Container(
                width: 80,
                height: 150,
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
                          Icons.close_outlined,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Text(
                          'MPIN could not be generated',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  void showImagePickerDialog() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: imageFile == null
                          ? CircleAvatar(
                              backgroundImage:
                                  AssetImage('images/default_user.png'),
                              backgroundColor: Colors.white,
                              radius: 44,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: Image.file(
                                imageFile,
                                width: 80.0,
                                height: 80.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 90),
                      child: Text(
                        'Choose image from: ',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton.icon(
                            onPressed: () {
                              getImage(true);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            label: Text(
                              'Camera',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: Icon(
                              Icons.camera_enhance_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            textColor: Colors.white,
                            splashColor: Colors.white,
                            color: Colors.red,
                            elevation: 5,
                          ),
                          RaisedButton(
                            onPressed: () {
                              getImage(false);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            textColor: Colors.white,
                            splashColor: Colors.white,
                            color: Colors.red,
                            elevation: 5,
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/ic_gallery.png',
                                  height: 28,
                                  width: 28,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Gallery',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future getImage(bool isFromCamera) async {
    String imagePath = "";

    if (isFromCamera) {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          imagePath = pickedFile.path;
          imageFile = File(imagePath);
        });

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(
            Constants.SHARED_PREF_USER_DP_PATH, imagePath);

        String _base64String = base64Encode(imageFile.readAsBytesSync());

        HTTPService()
            .uploadProfilePicture(authToken, _base64String)
            .then((response) => {
                  if (response.statusCode == 200)
                    print('Upload successful')
                  else
                    print('Upload unsuccessful')
                });

        Navigator.of(context).pop();
      }
    } else {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          imagePath = pickedFile.path;
          imageFile = File(imagePath);
        });

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(
            Constants.SHARED_PREF_USER_DP_PATH, imagePath);

        String _base64String = base64Encode(imageFile.readAsBytesSync());
        print('Image string: $_base64String');

        HTTPService()
            .uploadProfilePicture(authToken, _base64String)
            .then((response) => {
                  if (response.statusCode == 200)
                    print('Upload successful')
                  else
                    print('Upload unsuccessful')
                });

        Navigator.of(context).pop();
      }
    }
  }
}
