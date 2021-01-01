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

  void searchFunction(String searchWord) {
    if (searchWord == '') {
      setState(() {
        toBePlaced = PaginatePaidUsersAll();
      });
    } else {
      setState(() {
        toBePlaced = PaginatePaidUsersUsername(searchWord);
      });
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
