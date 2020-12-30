import 'package:biller/Utils/StaticUser.dart';
import 'package:biller/Widgets/NoResult.dart';
import 'package:flutter/material.dart';

import 'BalanceScreen.dart';

class BalanceScreenMiddleWare extends StatefulWidget {
  @override
  _BalanceScreenMiddleWareState createState() =>
      _BalanceScreenMiddleWareState();
}

class _BalanceScreenMiddleWareState extends State<BalanceScreenMiddleWare> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserIsAdmin) {
      return BalanceScreen();
    } else {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Image.asset('assets/notfound.png'),
              ),
              Text(
                "You Don't have Permission to view this page",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
