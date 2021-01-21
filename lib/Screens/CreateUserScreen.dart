import 'dart:ui';

import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/BackButtonWidget.dart';
import 'package:biller/Widgets/HalfAndFullFields.dart';
import 'package:biller/Widgets/LodingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  bool isfibernet = true;
  String userName;
  String serialNumber;
  String phoneNumber;
  String houseNumber;
  String streetNumber;
  String landMark;
  String village;
  String address;
  String oldDueBeforeApp;
  int dueToAdd = 0;
  int userNumber = 0;
  bool adding = false;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<bool> validateAllFields() async {
    if (userName == '' || serialNumber == '' || phoneNumber == '') return false;
    if (userName == null || serialNumber == null || phoneNumber == null)
      return false;
    userName = userName.trim().toLowerCase();
    serialNumber = serialNumber.trim().toLowerCase();
    phoneNumber = phoneNumber.trim();
    if (userName == '' || serialNumber == '' || phoneNumber == '') return false;
    address = '';
    if (village != null) {
      village = village.trim();
      if (village != '') address += village + ', ';
    }
    if (landMark != null) {
      landMark = landMark.trim();
      if (landMark != '') address += landMark + ', ';
    }
    if (streetNumber != null) {
      streetNumber = streetNumber.trim();
      if (streetNumber != '') address += streetNumber + ', ';
    }
    if (houseNumber != null) {
      houseNumber = houseNumber.trim();
      if (houseNumber != '') address += houseNumber + ', ';
    }
    if (address == '') return false;
    address = address.substring(0, address.length - 2);
    if (oldDueBeforeApp == null || oldDueBeforeApp == '') {
      setState(() {
        dueToAdd = 0;
      });
    } else {
      oldDueBeforeApp = oldDueBeforeApp.trim();
      try {
        setState(() {
          dueToAdd = int.parse(oldDueBeforeApp);
        });
      } catch (e) {
//        print(e);
        setState(() {
          dueToAdd = 0;
        });
        return false;
      }
    }
    return true;
  }

//  Future<bool> addUser() async {
//    setState(() {
//      isLoading = true;
//    });
//
//    bool isSuccess = await validateAllFields();
//    if (isSuccess) {
//      //load pack details
//
//      try {
//        int basePackAmount;
//        String basePackSummary;
//        int fibernetUserCount;
//        int tcnUserCount;
//        await _firestore
//            .collection('packs')
//            .doc('basepack')
//            .get()
//            .then((value) {
////                          print(value['fpack']);
//          if (isfibernet) {
//            basePackAmount = value['fpack'];
//            basePackSummary = value['fsummary'];
//          } else {
//            basePackAmount = value['tpack'];
//            basePackSummary = value['tsummary'];
//          }
//          fibernetUserCount = value['fcount'];
//          tcnUserCount = value['tcount'];
//        });
//        var batch = _firestore.batch();
//        await batch.set(_firestore.collection('users').doc(), {
//          'username': userName,
//          'phone': phoneNumber,
//          'serial': serialNumber,
//          'isfibernet': isfibernet,
//          'address': address,
//          'totaldue': 0,
//          'currentpackamount': basePackAmount,
//          'currentpacksummary': basePackSummary,
//          'currentpackpaidon': '',
//        });
//        if (isfibernet)
//          fibernetUserCount += 1;
//        else
//          tcnUserCount += 1;
//        await batch.update(
//            _firestore.collection('packs').doc('basepack'),
//            <String, dynamic>{
//              'fcount': fibernetUserCount,
//              'tcount': tcnUserCount,
//            });
//        await batch.commit();
//        setState(() {
//          isLoading = false;
//        });
//        Navigator.pop(context);
//      } catch (e) {
//        print(e);
//        //TODO: snackbar saying something went wrong
//      }
//      setState(() {
//        isLoading = false;
//      });
//      return true;
//    } else {
//      //TODO: implement a snack bar saying Enter required values
//      // like name, phone, serial, at least village
//      setState(() {
//        isLoading = false;
//      });
//      return false;
//    }
//  }

//  Future<bool> addUserMODIFIED() async {
//    setState(() {
//      isLoading = true;
//    });
//    bool isSuccess = await validateAllFields();
//    if (isSuccess) {
//      //load pack details
//      try {
//        int basePackAmount;
//        String basePackSummary;
//        int fibernetUserCount;
//        int tcnUserCount;
//        int pastAmount = 0;
//        int presentAmount = 0;
//        await _firestore.collection('admin').doc('amount').get().then((value) {
//          pastAmount = value['monthlybalance'];
//        });
//        await _firestore
//            .collection('packs')
//            .doc('basepack')
//            .get()
//            .then((value) {
////                          print(value['fpack']);
//          if (isfibernet) {
//            basePackAmount = value['fpack'];
//            basePackSummary = value['fsummary'];
//          } else {
//            basePackAmount = value['tpack'];
//            basePackSummary = value['tsummary'];
//          }
//          presentAmount = pastAmount + basePackAmount;
//          fibernetUserCount = value['fcount'];
//          tcnUserCount = value['tcount'];
//        });
//        var batch = _firestore.batch();
//        await batch.set(_firestore.collection('users').doc(), {
//          'username': userName,
//          'phone': phoneNumber,
//          'serial': serialNumber,
//          'isfibernet': isfibernet,
//          'address': address,
//          'totaldue': 0,
//          'currentpackamount': basePackAmount,
//          'currentpacksummary': basePackSummary,
//          'currentpackpaidon': '',
//        });
//        if (isfibernet)
//          fibernetUserCount += 1;
//        else
//          tcnUserCount += 1;
//        await batch.update(
//            _firestore.collection('admin').doc('amount'), <String, dynamic>{
//          'monthlybalance': presentAmount,
//        });
//        await batch.update(
//            _firestore.collection('packs').doc('basepack'), <String, dynamic>{
//          'fcount': fibernetUserCount,
//          'tcount': tcnUserCount,
//        });
//        await batch.commit();
//        setState(() {
//          isLoading = false;
//        });
//        Navigator.pop(context);
//      } catch (e) {
//        print(e);
//        //TODO: snackbar saying something went wrong
//      }
//      setState(() {
//        isLoading = false;
//      });
//      return true;
//    } else {
//      //TODO: implement a snack bar saying Enter required values
//      // like name, phone, serial, at least village
//      setState(() {
//        isLoading = false;
//      });
//      return false;
//    }
//  }

  Future<bool> addUserMODIFIED() async {
    setState(() {
      isLoading = true;
      adding = true;
    });
    bool isSuccess = await validateAllFields();
    if (isSuccess) {
      //load pack details
      try {
        int basePackAmount;
        String basePackSummary;
        int fibernetUserCount;
        int tcnUserCount;
        int pastAmount = 0;
        int presentAmount = 0;
        int dueFromLastMonth = 0;
        await _firestore.collection('admin').doc('amount').get().then((value) {
          pastAmount = value['monthlybalance'];
          dueFromLastMonth = value['duefromlastmonth'];
        });
        await _firestore
            .collection('packs')
            .doc('basepack')
            .get()
            .then((value) {
//                          print(value['fpack']);
          if (isfibernet) {
            basePackAmount = value['fpack'];
            basePackSummary = value['fsummary'];
          } else {
            basePackAmount = value['tpack'];
            basePackSummary = value['tsummary'];
          }
          presentAmount = pastAmount + basePackAmount;
          fibernetUserCount = value['fcount'];
          tcnUserCount = value['tcount'];
        });
        var batch = _firestore.batch();
        await batch.set(_firestore.collection('users').doc('$userNumber'), {
          'username': userName,
          'phone': phoneNumber,
          'serial': serialNumber,
          'isfibernet': isfibernet,
          'address': address,
          'totaldue': dueToAdd,
          'currentpackamount': basePackAmount,
          'currentpacksummary': basePackSummary,
          'currentpackpaidon': '',
          'id': userNumber,
        });
        if (dueToAdd > 0) {
          //create bill object and add to last month due
          await batch.set(_firestore.collection('bills').doc(), {
            'amountcollected': 0,
            'topay': dueToAdd,
            'paid': 0,
            'due': dueToAdd,
            'paidon': '2020-10-01',
            'userid': '$userNumber',
            'summary': '$dueToAdd Old Due before Using App',
          });
          dueFromLastMonth = dueFromLastMonth + dueToAdd;
        }
        if (isfibernet)
          fibernetUserCount += 1;
        else
          tcnUserCount += 1;
        await batch.update(
            _firestore.collection('admin').doc('amount'), <String, dynamic>{
          'monthlybalance': presentAmount,
          'duefromlastmonth': dueFromLastMonth
        });
        await batch.update(
            _firestore.collection('packs').doc('basepack'), <String, dynamic>{
          'fcount': fibernetUserCount,
          'tcount': tcnUserCount,
          'usernumber': userNumber + 1,
        });
        await batch.commit();
        setState(() {
          adding = false;
          isLoading = false;
        });
        Navigator.pop(context);
      } catch (e) {
        print(e);
        //TODO: snackbar saying something went wrong
      }
      setState(() {
        adding = false;
        isLoading = false;
      });
      return true;
    } else {
      //TODO: implement a snack bar saying Enter required values
      // like name, phone, serial, at least village
      setState(() {
        adding = false;
        isLoading = false;
      });
      return false;
    }
  }

  Future<bool> loadUserNumber() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _firestore.collection('packs').doc('basepack').get().then((value) {
        userNumber = value['usernumber'];
        print('>>>>>>>>>>');
        print(userNumber);
      });
    } catch (e) {
//      print(e);
      print("sone isssssue ");
      Navigator.pop(context);
    }

    await setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadUserNumber());
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Fugaz',
                                    fontSize: 28,
                                    color: kPrimaryColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Biller',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '.',
                                      style: TextStyle(
                                        color: kSecondaryColor,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Add New Customer $userNumber',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                          FullLengthField(LineIcons.user, 'Enter Username',
                              (value) {
                            userName = value;
                          }),
                          FullLengthField(
                              LineIcons.sort_alpha_desc, 'Serial Number',
                              (value) {
                            serialNumber = value;
                          }),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isfibernet = true;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 34, vertical: 18),
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          'AP Fibernet',
                                          style: TextStyle(
                                            color: isfibernet
                                                ? Colors.white
                                                : kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: isfibernet
                                            ? kPrimaryColor
                                            : kDimBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isfibernet = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 34, vertical: 18),
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          'TCN Digital',
                                          style: TextStyle(
                                            color: isfibernet
                                                ? kPrimaryColor
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: isfibernet
                                            ? kDimBackgroundColor
                                            : kSecondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FullLengthField(LineIcons.phone, 'Phone Number',
                              (value) {
                            phoneNumber = value;
                          }),
                          CustomLengthField(LineIcons.home, 'House Number',
                              (value) {
                            houseNumber = value;
                          }),
                          CustomLengthField(
                              LineIcons.street_view, 'Street Name', (value) {
                            streetNumber = value;
                          }),
                          FullLengthField(LineIcons.map, 'Landmark if any',
                              (value) {
                            landMark = value;
                          }),
                          CustomLengthField(LineIcons.globe, 'Village',
                              (value) {
                            village = value;
                          }),
                          FullLengthField(LineIcons.money, 'Old Due Before App',
                              (value) {
                            oldDueBeforeApp = value;
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
//                    print("Clicked Confirming");
                    await addUserMODIFIED();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 60,
                            child: Center(
                              child: Icon(
                                LineIcons.user,
                                color: Colors.white,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: kSecondaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 4,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? LoadingScreen(adding
                  ? 'Adding customer\nPlease Wait'
                  : 'Getting Customer Number\nPlease Wait')
              : Container(),
        ],
      ),
    );
  }
}
