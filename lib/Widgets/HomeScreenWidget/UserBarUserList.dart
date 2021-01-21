import 'package:biller/Screens/UserDetailScreen/UserDetailsScreen.dart';
import 'package:biller/Utils/constants.dart';
import 'package:biller/models/AppUser.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class UserBarUserList extends StatelessWidget {
  final AppUser user;
  UserBarUserList(this.user);

  @override
  Widget build(BuildContext context) {
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
//                child: Container(
//                  width: 100,
//                  height: 100,
//                  padding: EdgeInsets.all(20.0),
//                  child: Container(
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(60.0),
//                      color:
//                      user.isfibernet ? kPrimaryColor : kSecondaryColor,
//                    ),
//                  ),),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      user.isfibernet ? kPrimaryColor : kSecondaryColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: DottedLine(
                  direction: Axis.vertical,
                  lineLength: double.infinity,
                  lineThickness: 2.0,
                  dashLength: 4.0,
                  dashColor: Colors.black38,
                  dashRadius: 8.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.username,
                        style: kFontStyleForFibernet,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Serial Number: ${user.serial}',
                        style: kFontStyleForNormalText,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            user.isfibernet ? 'AP Fibernet' : 'TCN Digital',
                            style: kFontStyleForConnectionType,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              user.userid,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF7C7C7C),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: kViewBarColor,
          ),
        ),
      ),
    );
  }
}
