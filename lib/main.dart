import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/ui/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  await Firebase.initializeApp();

  // Future<void> backgroundMessageHandler(RemoteMessage message) async {
  //   Map<String, dynamic> messageMap = message.data;
  //   print('Message received in background');
  //   print('Game Name : ${messageMap['gamename']}');
  //   print('Game Result : ${messageMap['resul']}');
  //
  //   // if (message.containsKey('data')) {
  //   //   // Handle data message
  //   //   final dynamic data = message['data'];
  //   // }
  //   //
  //   // if (message.containsKey('notification')) {
  //   //   // Handle notification message
  //   //   final dynamic notification = message['notification'];
  //   // }
  // }

  handleNotifs();
  runApp(MyApp());
}

Future<void> handleNotifs() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // if (Platform.isIOS) {
  //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
  //     // save the token  OR subscribe to a topic here
  //   });
  //
  //   _fcm.requestNotificationPermissions(IosNotificationSettings());
  // }

  String fcmToken = await _firebaseMessaging.getToken();
  print('FCM Token: $fcmToken');

  SharedPreferences.getInstance().then((sharedPrefs) {
    sharedPrefs.setString(Constants.SHARED_PREF_FCM_TOKEN, fcmToken);
  });

  FirebaseMessaging.onMessage.listen((remoteMessage) {
    Map<String, dynamic> messageMap = remoteMessage.data;
    print('Message received in onMessage');
  });

  Future.delayed(Duration(seconds: 2), () {
    FirebaseMessaging.onBackgroundMessage((message) {
      Map<String, dynamic> messageMap = message.data;
      print('Message received in background');
      return;
    });
  });

  // _firebaseMessaging.configure(
  //   onMessage: (Map<String, dynamic> message) async {
  //     print("onMessage: $message");
  //   },
  //   onBackgroundMessage: backgroundMessageHandler,
  //   onLaunch: (Map<String, dynamic> message) async {
  //     print("onLaunch: $message");
  //   },
  //   onResume: (Map<String, dynamic> message) async {
  //     print("onResume: $message");
  //   },
  // );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ratan Matka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        primaryColor: Color(0xffcc0000),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      // home: DashboardScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
