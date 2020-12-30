import 'dart:ui';

import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/BackButtonWidget.dart';
import 'package:biller/Widgets/LodingScreen.dart';
import 'package:biller/Widgets/UserDetailScreenWidgets/DetailBar.dart';
import 'package:biller/models/AppUser.dart';
import 'package:biller/models/Bill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  final AppUser user;
  ConfirmPaymentScreen(this.user);
  @override
  _ConfirmPaymentScreenState createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  AppUser user;
  final TextEditingController _textController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<bool> clearBill(int enteredAmount) async {
    setState(() {
      isLoading = true;
    });
    bool isSuccess = true;
    var currentDate = DateTime.now();
    String currmon = currentDate.month > 9
        ? '${currentDate.month}'
        : '0${currentDate.month}';
    String currdate =
        currentDate.day > 9 ? '${currentDate.day}' : '0${currentDate.day}';
    String todayDate = '${currentDate.year}-$currmon-$currdate';
    String yearMonthString = '${currentDate.year}-$currmon';
    int givenAmount = enteredAmount;
    int userBillWithDue = user.totaldue + user.currentpackamount;
    int thisMonthAmount = user.currentpackamount;
    int userTotalDue = user.totaldue;

    try {
      var batch = _firestore.batch();
      if (givenAmount == userBillWithDue) {
        // generate bill object with due 0,
        await batch.set(_firestore.collection('bills').doc(), {
          'amountcollected': givenAmount,
          'topay': thisMonthAmount,
          'paid': thisMonthAmount,
          'due': 0,
          'paidon': todayDate,
          'userid': user.userid,
          'summary': user.currentpacksummary +
              " + Paid $thisMonthAmount on $todayDate + Due 0 ",
        });
        // clear user total due and make current month paid
        await batch.update(
            _firestore.collection('users').doc(user.userid), <String, dynamic>{
          'currentpackpaidon': todayDate,
          'totaldue': 0,
        });
        //clear all other bills 0 and add summary
        await _firestore
            .collection('bills')
            .where('userid', isEqualTo: user.userid)
            .where('due', isNotEqualTo: 0)
            .get()
            .then((querySnapshot) async {
          querySnapshot.docs.forEach((element) async {
            int actualDue = element['due'];
            int thatMonthToPay = element['topay'];
            String summary =
                element['summary'] + " + Due $actualDue cleared on $todayDate ";
            await batch.update(
                _firestore.collection('bills').doc(element.id),
                <String, dynamic>{
                  'due': 0,
                  'summary': summary,
                  'paid': thatMonthToPay
                });
            print("making due 0");
            print(element.id);
          });
        });
      } else {
        // 3 cases
        if (givenAmount <= thisMonthAmount) {
          int thisMonthDue = thisMonthAmount - givenAmount;
          //Generate bill object
          String summary = user.currentpacksummary +
              " + Paid $givenAmount on $todayDate + Due $thisMonthDue";
          await batch.set(_firestore.collection('bills').doc(), {
            'amountcollected': givenAmount,
            'topay': thisMonthAmount,
            'paid': givenAmount,
            'due': thisMonthDue,
            'paidon': todayDate,
            'userid': user.userid,
            'summary': summary,
          });
          int userTotalDueAfterPayment = user.totaldue + thisMonthDue;
          await batch.update(
              _firestore.collection('users').doc(user.userid),
              <String, dynamic>{
                'currentpackpaidon': todayDate,
                'totaldue': userTotalDueAfterPayment,
              });
        } else {
          // generate bill object with due 0,
          await batch.set(_firestore.collection('bills').doc(), {
            'amountcollected': givenAmount,
            'topay': thisMonthAmount,
            'paid': thisMonthAmount,
            'due': 0,
            'paidon': todayDate,
            'userid': user.userid,
            'summary': user.currentpacksummary +
                " + Paid $thisMonthAmount on $todayDate + Due 0 ",
          });
          // clear some user total due and make current month paid
          int remainingAmount = givenAmount - thisMonthAmount;
          int modifiedUserTotalDue = userTotalDue - remainingAmount;
          await batch.update(
              _firestore.collection('users').doc(user.userid),
              <String, dynamic>{
                'currentpackpaidon': todayDate,
                'totaldue': modifiedUserTotalDue,
              });
          // come on delete some bills due and add summary
          await _firestore
              .collection('bills')
              .where('userid', isEqualTo: user.userid)
              .where('due', isNotEqualTo: 0)
              .get()
              .then((querySnapshot) async {
            List<List<dynamic>> list = [];
            querySnapshot.docs.forEach((element) async {
              Bill bill = Bill(
                  element['topay'],
                  element['paid'],
                  element['due'],
                  element['paidon'],
                  element['summary'],
                  element['userid']);
              list.add([element['paidon'], element.id, bill]);
            });
            for (int i = 0; i < list.length - 1; i++) {
              for (int j = i + 1; j < list.length; j++) {
                if (list[i][0].compareTo(list[j][0]) >= 0) {
                  dynamic temp = list[i];
                  list[i] = list[j];
                  list[j] = temp;
                }
              }
            }
            print(list);
            int tempRem = remainingAmount;
            int i = 0;
            while (tempRem > 0) {
              Bill bill = list[i][2];
              String id = list[i][1];
              int due = bill.due;
              int slash = tempRem - due;
              if (slash >= 0) {
                await batch.update(
                    _firestore.collection('bills').doc(id), <String, dynamic>{
                  'due': 0,
                  'summary': bill.summary +
                      " + Due ${bill.due} cleared on $todayDate ",
                  'paid': bill.topay,
                });
                print('_______ Clearing $due _______ = 0');
              } else {
                int stillDue = due - tempRem;
                await batch.update(
                    _firestore.collection('bills').doc(list[i][1]),
                    <String, dynamic>{
                      'due': stillDue,
                      'summary': bill.summary +
                          " + Due ${tempRem} Paid on $todayDate + $stillDue remaining ",
                      'paid': tempRem,
                    });
                print('_______ Slashing $due ________ = $stillDue');
              }
              tempRem = tempRem - due;
              i++;
            }
          });
        }
      }
      // add amount to monthly collection
      await batch.set(
          _firestore.collection('monthly/$yearMonthString/payings').doc(), {
        'a': givenAmount,
      });
      await batch.commit();
      print("---------------------BAtch Successfull-----------------------");
      isSuccess = true;
    } catch (e) {
      isSuccess = false; //TODO: implement snackbar saying something went wrong
    }
    setState(() {
      isLoading = false;
    });
    return isSuccess;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
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
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 14, bottom: 14),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 34, vertical: 16),
                                          child: Row(
                                            children: [
                                              Text(
                                                '₹',
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: TextField(
                                                  controller: _textController,
                                                  style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText:
                                                              'Enter Amount',
                                                          fillColor:
                                                              kPrimaryColor,
                                                          hintStyle: TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: kDimBackgroundColor,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Details',
                                          style: TextStyle(
                                            color: kDullFontColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 14, bottom: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 34, vertical: 16),
                                              child: Center(
                                                child: Text(
                                                  'To Pay',
                                                  style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontWeight: FontWeight.w900,
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
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 34, vertical: 16),
                                              child: Center(
                                                child: Text(
                                                  '₹ ${user.totaldue + user.currentpackamount}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DottedLine(
                                        direction: Axis.horizontal,
                                        lineLength: double.infinity,
                                        lineThickness: 4.0,
                                        dashLength: 4.0,
                                        dashColor: Colors.black38,
                                        dashRadius: 8.0,
                                        dashGapLength: 4.0,
                                        dashGapColor: Colors.transparent,
                                        dashGapRadius: 0.0,
                                      ),
                                      DetailBar('Current Pack',
                                          '₹ ${user.currentpackamount}'),
                                      DetailBar('Total Due ',
                                          '+ ₹ ${user.totaldue}', 'warn'),
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16, left: 24, right: 24),
                  child: GestureDetector(
                    onTap: () async {
                      //TODO: implement payment functionality
                      print("Confirm");
//                      print(_textController.text);
                      if (_textController.text != null) {
                        if (_textController.text == '') return;
                        try {
                          int val = int.parse(_textController.text.trim());
                          if (val <= 0) return;
                          if (val > user.totaldue + user.currentpackamount)
                            return;
//                          print(val);
                          bool isSuccess = await clearBill(val);
                          if (isSuccess) Navigator.pop(context, true);
                        } catch (e) {
                          print("Entered Amount is invalid");
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? LoadingScreen('Confirming Bill\nPlease Wait')
              : Container(),
        ],
      ),
    );
  }
}
