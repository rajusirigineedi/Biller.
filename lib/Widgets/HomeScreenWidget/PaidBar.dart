import 'package:biller/Screens/UserDetailScreen/UserDetailsScreen.dart';
import 'package:biller/Utils/constants.dart';
import 'package:biller/models/AppUser.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class PaidBar extends StatelessWidget {
  final AppUser user;

  PaidBar(this.user);

  @override
  Widget build(BuildContext context) {
    bool paidBill = (user.currentpackpaidon != '');
    return Padding(
      padding: EdgeInsets.only(top: 4.0, left: 4, right: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailsScreen(user),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 120,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        paidBill ? 'PAID' : 'UN\nPAID',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: DottedLine(
                  direction: Axis.vertical,
                  lineLength: double.infinity,
                  lineThickness: 2.0,
                  dashLength: 4.0,
                  dashColor: Colors.white70,
                  dashRadius: 8.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.username,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Serial Number: ${user.serial}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        user.isfibernet ? 'AP Fibernet' : 'TCN Digital',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: paidBill ? kPrimaryColor : kSecondaryColor,
          ),
        ),
      ),
    );
  }
}
