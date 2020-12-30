import 'package:biller/Screens/UserDetailScreen/DueBillsFragment.dart';
import 'package:biller/Screens/UserDetailScreen/MonthlyBillFragment.dart';
import 'package:biller/Screens/UserDetailScreen/OldBillsFragment.dart';
import 'package:biller/Screens/UserDetailScreen/UpgradePackFragment.dart';
import 'package:biller/Screens/UserDetailScreen/UserDetailsFragment.dart';
import 'package:biller/Utils/StaticUser.dart';
import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/BackButtonWidget.dart';
import 'package:biller/Widgets/LodingScreen.dart';
import 'package:biller/models/AppUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  AppUser user;
  UserDetailsScreen(this.user);
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  List<bool> buttonList = [true, false, false, false, false];
  AppUser user;
  List<Widget> widgetList;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String upgradeMessage = 'Upgrading Pack\nPlease Wait';
  String deletingMessage = 'Deleting User\nPlease Wait';
  bool isUpgrading = true;

  Widget getCorrectWidget() {
    for (int i = 0; i < buttonList.length; i++)
      if (buttonList[i]) return widgetList[i];
  }

  void upgradePack(int amount, String summary, bool isExtension) async {
    setState(() {
      isLoading = true;
      isUpgrading = true;
    });
    try {
      print(amount);
      print(isExtension);
      print(summary);
      var batch = _firestore.batch();
      int pastAmount = 0;
      int presentAmount = 0;

      await _firestore.collection('admin').doc('amount').get().then((value) {
        pastAmount = value['extensions'];
      });

      if (isExtension) {
        print("Extension adding");
        var currentDate = DateTime.now();
        String currmon = currentDate.month > 9
            ? '${currentDate.month}'
            : '0${currentDate.month}';
        String currdate =
            currentDate.day > 9 ? '${currentDate.day}' : '0${currentDate.day}';
        String todayDate = '${currentDate.year}-$currmon-$currdate';
        // updating in user
        await batch.update(
            _firestore.collection('users').doc(user.userid), <String, dynamic>{
          'currentpackamount': user.currentpackamount + amount,
          'currentpacksummary': user.currentpacksummary +
              ' + $amount extension pack added on $todayDate : $summary ',
        });
        // add presentAmount to pastAmount
        presentAmount = pastAmount + amount;
      } else {
        print("changing pack");
        // Updating in user
        await _firestore
            .collection('users')
            .doc(user.userid)
            .update(<String, dynamic>{
          'currentpackamount': amount,
          'currentpacksummary': summary,
        });
        // remove user.currentpack and add new pack
        presentAmount = pastAmount - user.currentpackamount + amount;
      }

      await batch.update(
          _firestore.collection('admin').doc('amount'), <String, dynamic>{
        'extensions': presentAmount,
      });

      await batch.commit();
      Navigator.pop(context);
    } catch (e) {
      print(e);
      //TODO: implement a snackbar saying something went wrong
    }
    setState(() {
      isLoading = false;
    });
  }

  void deleteUser() async {
    setState(() {
      isLoading = true;
      isUpgrading = false;
    });
    try {
      int fibernetUserCount;
      int tcnUserCount;
      await _firestore.collection('packs').doc('basepack').get().then((value) {
        fibernetUserCount = value['fcount'];
        tcnUserCount = value['tcount'];
      });
      if (user.isfibernet)
        fibernetUserCount -= 1;
      else
        tcnUserCount -= 1;
      var batch = _firestore.batch();
      await batch.delete(_firestore.collection('users').doc(user.userid));

      await batch.update(
          _firestore.collection('packs').doc('basepack'), <String, dynamic>{
        'fcount': fibernetUserCount,
        'tcount': tcnUserCount,
      });

      await batch.commit();
      Navigator.pop(context);
    } catch (e) {
      print(e);
      //TODO: implement a snackbar saying something went wrong
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
    widgetList = [
      MonthlyBillFragment(user),
      OldBillsFragment(user),
      UserDetailsFragment(user, deleteUser),
      DueBillsFragment(user),
      UpgradePackFragment(user, upgradePack),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              ListingButton('Monthly', buttonList[0], () {
                                setState(() {
                                  for (int i = 0; i < buttonList.length; i++)
                                    buttonList[i] = false;
                                  buttonList[0] = true;
                                });
                              }),
                              ListingButton('Recent bills', buttonList[1], () {
                                setState(() {
                                  for (int i = 0; i < buttonList.length; i++)
                                    buttonList[i] = false;
                                  buttonList[1] = true;
                                });
                              }),
                              ListingButton('User Details', buttonList[2], () {
                                setState(() {
                                  for (int i = 0; i < buttonList.length; i++)
                                    buttonList[i] = false;
                                  buttonList[2] = true;
                                });
                              }),
                              ListingButton('Due bills', buttonList[3], () {
                                setState(() {
                                  for (int i = 0; i < buttonList.length; i++)
                                    buttonList[i] = false;
                                  buttonList[3] = true;
                                });
                              }),
                              (currentUserIsAdmin &&
                                      user.currentpackpaidon == '')
                                  ? ListingButton('Upgrade Pack', buttonList[4],
                                      () {
                                      setState(() {
                                        for (int i = 0;
                                            i < buttonList.length;
                                            i++) buttonList[i] = false;
                                        buttonList[4] = true;
                                      });
                                    })
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: getCorrectWidget(),
                    ),
                  )
                ],
              ),
            ),
            isLoading
                ? LoadingScreen(isUpgrading ? upgradeMessage : deletingMessage)
                : Container(),
          ],
        ));
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
