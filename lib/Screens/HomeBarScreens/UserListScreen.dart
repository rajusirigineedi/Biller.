//import 'package:biller/Screens/CreateUserScreen.dart';
//import 'package:biller/Utils/constants.dart';
//import 'package:biller/Widgets/HomeScreenWidget/SearchBar.dart';
//import 'package:biller/Widgets/PaginationWidgets/PaginateAllUsers.dart';
//import 'package:biller/Widgets/PaginationWidgets/PaginateSearchedUsers.dart';
//import 'package:biller/Widgets/PaginationWidgets/PaginateSearchedUsersSerial.dart';
//import 'package:flutter/material.dart';
//import 'package:line_icons/line_icons.dart';
//
//class UserListScreen extends StatefulWidget {
//  @override
//  _UserListScreenState createState() => _UserListScreenState();
//}
//
//class _UserListScreenState extends State<UserListScreen> {
//  String searchWord;
//  var correctPaginatingWidget;
//
//  void searchData(String searchWord) {
//    setState(() {
//      this.searchWord = searchWord;
//      if (searchWord == '' || searchWord == null) {
//        correctPaginatingWidget = PaginateAllUsers();
//      } else {
//        print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
//        print(searchWord);
//        bool usernamequery = true;
//        if (usernamequery) {
//          correctPaginatingWidget = PaginateSearchedUsers(searchWord);
//        } else {
//          correctPaginatingWidget = PaginateSearchedUsersSerial(searchWord);
//        }
//      }
//    });
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    searchData('');
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.white,
//      body: SafeArea(
//        child: Container(
//            child: Column(
//          crossAxisAlignment: CrossAxisAlignment.end,
//          children: [
//            SearchBar(searchData),
//            Expanded(
//              child: correctPaginatingWidget,
//            ),
//          ],
//        )),
//      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(LineIcons.user_plus),
//        backgroundColor: kSecondaryColor,
//        elevation: 0,
//        highlightElevation: 0,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.all(
//            Radius.circular(16.0),
//          ),
//        ),
//        onPressed: () async {
////          await _auth.signOut();
////          Navigator.push(
////            context,
////            MaterialPageRoute(
////              builder: (context) => LoginScreen(),
////            ),
////          );
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => CreateUserScreen(),
//            ),
//          );
//        },
//      ),
//    );
//  }
//}
