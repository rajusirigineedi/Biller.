import 'package:biller/Widgets/HomeScreenWidget/SearchBar.dart';
import 'package:flutter/material.dart';

import 'PaginatePaidUsersAll.dart';
import 'PaginatePaidUsersUsername.dart';

class PaidUsersHolder extends StatefulWidget {
  @override
  _PaidUsersHolderState createState() => _PaidUsersHolderState();
}

class _PaidUsersHolderState extends State<PaidUsersHolder> {
  Widget toBePlaced;

  void searchFunction(String searchWord, [bool username]) {
    if (searchWord == '') {
      setState(() {
        toBePlaced = PaginatePaidUsersAll();
      });
    } else {
      if (username != null) {
//        print("stirng called royy'");
        setState(() {
          toBePlaced = PaginatePaidUsersUsername(searchWord, true);
        });
      } else {
//        print("number called correclyt");
        setState(() {
          toBePlaced = PaginatePaidUsersUsername(searchWord, false);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toBePlaced = PaginatePaidUsersAll();
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
