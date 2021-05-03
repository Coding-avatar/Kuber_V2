import 'package:flutter/material.dart';
import 'package:kuber_starline/ui/DrawerScreen.dart';
import 'package:kuber_starline/ui/HomeScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawerEnableOpenDragGesture: false,
      drawer: DrawerScreen(),
      body: HomeScreen(),
    );
  }
}
