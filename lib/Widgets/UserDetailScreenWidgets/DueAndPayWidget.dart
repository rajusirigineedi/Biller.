import 'package:biller/Screens/BillDetailScreen/BillDetailScreen.dart';
import 'package:biller/Utils/constants.dart';
import 'package:biller/models/AppUser.dart';
import 'package:biller/models/Bill.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class DueAndPayWidgets extends StatelessWidget {
  final AppUser user;
  final Bill bill;
  DueAndPayWidgets(this.user, this.bill);

  @override
  Widget build(BuildContext context) {
    var arr = bill.paidon.split('-');
    String date = arr[2], year = arr[0];
    int month = int.parse(arr[1]);
//    print("month is                -");
//    print(month);
    return Padding(
      padding: EdgeInsets.only(top: 4.0, left: 4, right: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BillDetailScreen(user, bill),
            ),
          );
        },
        child: Container(
          height: 120,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kMonthList[month - 1],
                      style: TextStyle(
                        fontSize: 24,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        year,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
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
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '₹ ${bill.paid}',
                            style: TextStyle(
                              fontSize: 24,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Text(
                              '/ ${bill.topay} ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '₹ ${bill.due}',
                            style: TextStyle(
                              fontSize: 24,
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Text(
                              ' DUE ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: kSecondaryColor,
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
