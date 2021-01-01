import 'package:biller/Screens/PaginationScreens/UnPaidUsers/PaginateUnPaidUserAll.dart';
import 'package:biller/Screens/PaginationScreens/UnPaidUsers/PaginateUnPaidUserUsername.dart';
import 'package:biller/Widgets/HomeScreenWidget/SearchBar.dart';
import 'package:flutter/material.dart';

class UnPaidUsersHolder extends StatefulWidget {
  @override
  _UnPaidUsersHolderState createState() => _UnPaidUsersHolderState();
}

class _UnPaidUsersHolderState extends State<UnPaidUsersHolder> {
  Widget toBePlaced;

  void searchFunction(String searchWord, [bool username]) {
    if (searchWord == '') {
      setState(() {
        toBePlaced = PaginateUnPaidUsersAll();
      });
    } else {
      if (username != null) {
        print("stirng called royy'");
        setState(() {
          toBePlaced = PaginateUnPaidUserUsername(searchWord, true);
        });
      } else {
        print("number called correclyt");
        setState(() {
          toBePlaced = PaginateUnPaidUserUsername(searchWord, false);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toBePlaced = PaginateUnPaidUsersAll();
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
