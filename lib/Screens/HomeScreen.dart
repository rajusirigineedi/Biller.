import 'package:biller/Screens/HomeBarScreens/PaidListScreen.dart';
import 'package:biller/Screens/HomeBarScreens/UnPaidListScreen.dart';
import 'package:biller/Screens/HomeBarScreens/UserListScreen.dart';
import 'package:biller/Screens/PaginationScreens/AllUsers/AllUserHolder.dart';
import 'package:biller/Screens/PaginationScreens/PaidUsers/PaidUsersHolder.dart';
import 'package:biller/Screens/PaginationScreens/UnPaidUsers/UnPaidUsersHolder.dart';
import 'package:biller/Screens/PaginationTrailScreen.dart';
import 'package:biller/Utils/StaticUser.dart';
import 'package:biller/Utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeBarScreens/BalanceScreenMiddleWare.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    AllUserHolder(),
    PaidUsersHolder(),
    UnPaidUsersHolder(),
    BalanceScreenMiddleWare()
  ];

  void loadIfAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAdmin = await prefs.getBool('isAdmin') ?? false;
    currentUserIsAdmin = isAdmin;
    print(currentUserIsAdmin);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadIfAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white30, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.white30.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: kPrimaryColor,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Colors.transparent,
                tabs: [
                  GButton(
                    icon: LineIcons.user,
                    text: 'Users',
                  ),
                  GButton(
                    icon: LineIcons.heart_o,
                    text: 'Paid',
                  ),
                  GButton(
                    icon: LineIcons.chain_broken,
                    text: 'UnPaid',
                  ),
                  GButton(
                    icon: LineIcons.briefcase,
                    text: 'Balance',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
