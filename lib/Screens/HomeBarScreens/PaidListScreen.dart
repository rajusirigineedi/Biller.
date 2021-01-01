//import 'package:biller/Widgets/HomeScreenWidget/SearchBar.dart';
//import 'package:biller/Widgets/PaginationWidgets/PaginateAllUsers.dart';
//import 'package:biller/Widgets/PaginationWidgets/PaginateSearchedUsers.dart';
//import 'package:biller/Widgets/PaginationWidgets/PaginateSearchedUsersSerial.dart';
//import 'package:flutter/material.dart';
//
//class PaidListScreen extends StatefulWidget {
//  @override
//  _PaidListScreenState createState() => _PaidListScreenState();
//}
//
//class _PaidListScreenState extends State<PaidListScreen> {
//  String searchWord;
//  var correctPaginatingWidget;
//
//  void searchData(String searchWord) {
//    setState(() {
//      this.searchWord = searchWord;
//      if (searchWord == '' || searchWord == null) {
//        correctPaginatingWidget = PaginateAllUsersPaid();
//      } else {
//        print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
//        print(searchWord);
//        bool usernamequery = true;
//        if (usernamequery) {
//          correctPaginatingWidget = PaginateSearchedUsersPaid(searchWord);
//        } else {
//          correctPaginatingWidget =
//              PaginateSearchedUsersSerialUnPaid(searchWord);
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
//    );
//  }
//}
