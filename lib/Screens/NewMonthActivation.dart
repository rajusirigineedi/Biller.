import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/BackButtonWidget.dart';
import 'package:biller/Widgets/HalfAndFullFields.dart';
import 'package:biller/Widgets/LodingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class NewMonthActivation extends StatefulWidget {
  @override
  _NewMonthActivationState createState() => _NewMonthActivationState();
}

class _NewMonthActivationState extends State<NewMonthActivation> {
  bool isLoading = false;
  String fpack;
  String fsummary;
  String tpack;
  String tsummary;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<bool> validateAllFields() async {
    if (fpack == '' || fsummary == '' || tpack == '' || tsummary == '')
      return false;
    if (fpack == null || fsummary == null || tpack == null || tsummary == null)
      return false;
    fpack = fpack.trim();
    tpack = tpack.trim();
    return true;
  }

  Future<int> getPreviousMonthCollected(String previousMonthYearString) async {
    int previousMonthCollected = 0;

    try {
      await _firestore
          .collection('monthly/$previousMonthYearString/payings')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          print(element.id);
          previousMonthCollected += element['a'];
        });
      });
    } catch (e) {
      print(e);
    }

    print('Total collected this month $previousMonthCollected');
    return previousMonthCollected;
  }

  Future<int> getAdjustment(String previousMonthYearString) async {
    int fibpack;
    int tcnpack;
    int fibernetUsers;
    int tcnUsers;
    int extensions;
    int oldDue;
    await _firestore.collection('admin').doc('amount').get().then((value) {
      setState(() {
        oldDue = value['duefromlastmonth'];
        extensions = value['extensions'];
      });
    });
    await _firestore.collection('packs').doc('basepack').get().then((value) {
      fibpack = value['fpack'];
      tcnpack = value['tpack'];
      fibernetUsers = value['fcount'];
      tcnUsers = value['tcount'];
    });
    int lastMonthCollected =
        await getPreviousMonthCollected(previousMonthYearString);
    int lastMonthSpent =
        fibernetUsers * fibpack + tcnUsers * tcnpack + extensions;
    int adjustment = lastMonthSpent - lastMonthCollected + oldDue;

    return adjustment;
  }

//  Future<int> getPreviousMonthSpentDEPRECATED() async {
//    int fibpack;
//    int tcnpack;
//    int fibernetUsers;
//    int tcnUsers;
//    await _firestore
//        .collection('users')
//        .where('isfibernet', isEqualTo: true)
//        .get()
//        .then((value) {
//      fibernetUsers = value.docs.length;
//    });
//    await _firestore
//        .collection('users')
//        .where('isfibernet', isEqualTo: false)
//        .get()
//        .then((value) {
//      tcnUsers = value.docs.length;
//    });
//    await _firestore.collection('packs').doc('basepack').get().then((value) {
//      fibpack = value['fpack'];
//      tcnpack = value['tpack'];
//    });
//    int amount = fibernetUsers * fibpack + tcnUsers * tcnpack;
//    return amount;
//  }
//
//  Future<int> getPreviousMonthTotalDEPRECATED(String previousMonthYearString) async {
//    int lastMonthCollected = 0;
//    String searchWord = previousMonthYearString;
//    await _firestore
//        .collection('bills')
//        .orderBy('paidon')
//        .startAt([searchWord])
//        .endAt([searchWord + '\uf8ff'])
//        .get()
//        .then((querySnapshot) {
//          querySnapshot.docs.forEach((element) {
//            print(element.id);
//            lastMonthCollected += element['amountcollected'];
//          });
//        });
//    print('Total collected this month $lastMonthCollected');
//    return lastMonthCollected;
//  }
//
//  Future<bool> adjustLastMonthDueDEPRECATED(
//      int fibpack, int tcnpack, String previousMonthYearString) async {
//    int oldMonthDue;
//    await _firestore.collection('admin').doc('amount').get().then((value) {
//      oldMonthDue = value['duefromlastmonth'];
//    });
//    // create and save due from last month and continue activating new pack
//    int lastMonthCollected =
//        await getPreviousMonthTotal(previousMonthYearString);
//    int lastMonthSpent = await getPreviousMonthSpent();
//
//    int lastMonthRemaining = lastMonthSpent + oldMonthDue - lastMonthCollected;
//    await _firestore.collection('admin').doc('amount').update(<String, dynamic>{
//      'duefromlastmonth': lastMonthRemaining,
//    });
//    return true;
//  }

  void activateNewMonth(int fibpack, int tcnpack) async {
    setState(() {
      isLoading = true;
    });
    var currentDate = DateTime.now();
    var prevDate = new DateTime(currentDate.year, currentDate.month - 1, 1);
    String prevmon =
        prevDate.month > 9 ? '${prevDate.month}' : '0${prevDate.month}';
    String prevday = prevDate.day > 9 ? '${prevDate.day}' : '0${prevDate.day}';
    String previousDateString = '${prevDate.year}-$prevmon-$prevday';
    String previousMonthYearString = '${prevDate.year}-$prevmon';

    String currmon = currentDate.month > 9
        ? '${currentDate.month}'
        : '0${currentDate.month}';
    String currday =
        currentDate.day > 9 ? '${currentDate.day}' : '0${currentDate.day}';
    String currDateString = '${currentDate.year}-$currmon-$currday';
    print(currDateString);
    print(previousDateString);
    try {
      int adjustment = await getAdjustment(previousMonthYearString);
      var batch = _firestore.batch();
      await batch.update(
          _firestore.collection('packs').doc('basepack'), <String, dynamic>{
        'fpack': fibpack,
        'fsummary': fsummary,
        'tpack': tcnpack,
        'tsummary': tsummary,
      });
      await _firestore.collection('users').get().then((querySnapshot) async {
        querySnapshot.docs.forEach((element) async {
          bool isfibernet = element['isfibernet'];
          bool currentPackPaid = element['currentpackpaidon'] != '';
          int userTotalDue = element['totaldue'];
          if (!currentPackPaid) {
            // generate bill object with full due,
            await batch.set(_firestore.collection('bills').doc(), {
              'amountcollected': 0,
              'topay': element['currentpackamount'],
              'paid': 0,
              'due': element['currentpackamount'],
              'paidon': previousDateString,
              'userid': element.id,
              'summary': element['currentpacksummary'] +
                  " + Didn't Paid + Due ${element['currentpackamount']} ",
            });
            // increment total due
            userTotalDue += element['currentpackamount'];
          }
          if (isfibernet) {
            await batch.update(
                _firestore.collection('users').doc(element.id),
                <String, dynamic>{
                  'currentpackamount': fibpack,
                  'currentpackpaidon': '',
                  'currentpacksummary': fsummary,
                  'totaldue': userTotalDue,
                });
          } else {
            await batch.update(
                _firestore.collection('users').doc(element.id),
                <String, dynamic>{
                  'currentpackamount': tcnpack,
                  'currentpackpaidon': '',
                  'currentpacksummary': tsummary,
                  'totaldue': userTotalDue,
                });
          }
          print("grabbing user");
          print(element.id);
        });
      });
      await batch.update(
          _firestore.collection('admin').doc('amount'), <String, dynamic>{
        'lastactivated': currDateString,
        'duefromlastmonth': adjustment,
        'extensions': 0,
      });
      // shift old month to new month .. since no collection it would automatically ignored
      await batch.commit();
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      //TODO: snackbar saying something went wrong ...
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                                'Activate New Month Packs',
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
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'AP Fibernet',
                                  style: TextStyle(
                                    color: kDullFontColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomLengthField(
                              LineIcons.rupee, 'Fibernet Basic Pack', (value) {
                            fpack = value;
                          }),
                          FullLengthField(LineIcons.sort_alpha_desc, 'Summary',
                              (value) {
                            fsummary = value;
                          }),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'TCN Digital',
                                  style: TextStyle(
                                    color: kDullFontColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomLengthField(LineIcons.rupee, 'TCN Basic Pack',
                              (value) {
                            tpack = value;
                          }),
                          FullLengthField(LineIcons.sort_alpha_desc, 'Summary',
                              (value) {
                            tsummary = value;
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    bool validationSuccess = await validateAllFields();
                    if (!validationSuccess) return;
                    int fibpack, tcnpack;
                    try {
                      fibpack = int.parse(fpack);
                      tcnpack = int.parse(tpack);
                    } catch (e) {
                      print(e);
                      return;
                    }
                    if (fibpack <= 0 || tcnpack <= 0) return;
                    // We are free from all edge conditions
                    await activateNewMonth(fibpack, tcnpack);
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
                                LineIcons.sign_in,
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
                                'Activate',
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
              ? LoadingScreen(
                  'Activating Pack\nPlease Wait\nIt might take some time')
              : Container(),
        ],
      ),
    );
  }
}
