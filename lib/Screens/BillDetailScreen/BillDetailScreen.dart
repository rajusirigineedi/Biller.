import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/BackButtonWidget.dart';
import 'package:biller/Widgets/UserDetailScreenWidgets/DetailBar.dart';
import 'package:biller/models/AppUser.dart';
import 'package:biller/models/Bill.dart';

import 'package:flutter/material.dart';

class BillDetailScreen extends StatelessWidget {
  final AppUser user;
  final Bill bill;
  BillDetailScreen(this.user, this.bill);

  @override
  Widget build(BuildContext context) {
    var arr = bill.paidon.split('-');
    String date = arr[2], year = arr[0];
    int month = int.parse(arr[1]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            BackButtonWidget(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.username,
                  style: TextStyle(
                    fontSize: 24,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
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
                Text(
                  user.isfibernet ? 'AP Fibernet' : 'TCN Digital',
                  style: kFontStyleForConnectionType,
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
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
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'Pack Details',
                                      style: TextStyle(
                                        color: kDullFontColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  DetailBar('Pack Amount', '₹ ${bill.topay}'),
                                  DetailBar('Paid ', '${bill.paid}'),
                                  DetailBar('Paid On', bill.paidon),
                                  DetailBar('Summary :', ''),
                                  Padding(
                                    padding: EdgeInsets.only(top: 14),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 34, vertical: 16),
                                      child: Center(
                                        child: Text(
                                          bill.summary,
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: kDimBackgroundColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListingButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final Function function;
  ListingButton(this.label, this.isActive, this.function);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: function,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? kDimBackgroundColor : kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: isActive ? kPrimaryColor : kDimBackgroundColor,
          ),
        ),
      ),
    );
  }
}
