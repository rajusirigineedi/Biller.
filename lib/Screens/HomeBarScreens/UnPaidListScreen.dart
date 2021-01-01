//import 'package:biller/Widgets/HomeScreenWidget/SearchBar.dart';
//import 'package:biller/Widgets/PaginationWidgets/PaginateAllUsers.dart';
//import 'package:biller/Widgets/PaginationWidgets/PaginateSearchedUsers.dart';
//import 'package:biller/Widgets/PaginationWidgets/PaginateSearchedUsersSerial.dart';
//import 'package:flutter/material.dart';
//
//class UnPaidListScreen extends StatefulWidget {
//  @override
//  _UnPaidListScreenState createState() => _UnPaidListScreenState();
//}
//
//class _UnPaidListScreenState extends State<UnPaidListScreen> {
//  String searchWord;
//  var correctPaginatingWidget;
//
//  void searchData(String searchWord) {
//    setState(() {
//      this.searchWord = searchWord;
//      if (searchWord == '' || searchWord == null) {
//        correctPaginatingWidget = PaginateAllUsersUnPaid();
//      } else {
//        print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
//        print(searchWord);
//        bool usernamequery = true;
//        if (usernamequery) {
//          correctPaginatingWidget = PaginateSearchedUsersUnPaid(searchWord);
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
