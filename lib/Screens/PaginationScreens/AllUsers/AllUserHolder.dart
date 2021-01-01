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

  void searchFunction(String searchWord) {
    if (searchWord == '') {
      setState(() {
        toBePlaced = PaginateUserAll();
      });
    } else {
      setState(() {
        toBePlaced = PaginateUserUsername(searchWord);
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
