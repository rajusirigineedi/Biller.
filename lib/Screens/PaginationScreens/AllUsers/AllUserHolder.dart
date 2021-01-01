import 'package:biller/Screens/PaginationScreens/AllUsers/PaginateUserAll.dart';
import 'package:biller/Widgets/HomeScreenWidget/SearchBar.dart';
import 'package:flutter/material.dart';

import 'PaginateUserUsername.dart';

class AllUserHolder extends StatefulWidget {
  @override
  _AllUserHolderState createState() => _AllUserHolderState();
}

class _AllUserHolderState extends State<AllUserHolder> {
  Widget toBePlaced;

  void searchFunction(String searchWord, [bool username]) {
    if (searchWord == '') {
      setState(() {
        toBePlaced = PaginateUserAll();
      });
    }
    if (username != null) {
      print("stirng called royy'");
      setState(() {
        toBePlaced = PaginateUserUsername(searchWord, true);
      });
    } else {
      print("number called correclyt");
      setState(() {
        toBePlaced = PaginateUserUsername(searchWord, false);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toBePlaced = PaginateUserAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            SearchBar(searchFunction),
            Expanded(
              child: toBePlaced,
            ),
          ]),
        ),
      ),
    );
  }
}
