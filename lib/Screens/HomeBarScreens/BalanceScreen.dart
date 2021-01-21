import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/LodingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import '../NewMonthActivation.dart';

class BalanceScreen extends StatefulWidget {
  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String yearMonthDateString;
  String yearMonthString;
  int dateString = 28;
  int month = 12;
  int todayCollection = 0;
  int monthCollection = 0;
  int dueFromLastMonth = 0;
  int thisMonthSpent = 0;
  String lastActivated;
  bool packActivated = true;
  DateTime _currentDate;

  int fibernetUsers = 0;
  int tcnUsers = 0;
  int percentage = 0;

  void calculatePercentage() async {
    setState(() {
      int got = monthCollection;
      int toget = thisMonthSpent + dueFromLastMonth;
      percentage = (got * 100 / toget).round();
      print(got);
      print(toget);
      print('<<<<<<<<<<<');
    });
  }

  Future<bool> getUsersCount() async {
    await _firestore.collection('packs').doc('basepack').get().then((value) {
      setState(() {
        fibernetUsers = value['fcount'];
        tcnUsers = value['tcount'];
      });
    });
    return true;
  }

  Future<bool> getThisMonthSpentMODIFIED(String searchDate) async {
    try {
      int monthlyBalance;
      await _firestore.collection('admin').doc('amount').get().then((value) {
        setState(() {
          dueFromLastMonth = value['duefromlastmonth'];
          lastActivated = value['lastactivated'];
          monthlyBalance = value['monthlybalance'];
        });
      });
      var la = lastActivated.substring(0, 7);
      var sd = searchDate.substring(0, 7);
      setState(() {
        packActivated = la.compareTo(sd) >= 0;
      });
//      print(la);
//      print(sd);
      int amount = monthlyBalance;
      setState(() {
        thisMonthSpent = amount;
      });
    } catch (e) {
      print(e);
      //TODO: same snackbar story
    }
    return true;
  }

  Future<bool> calculateThisDayTotal(String searchDate) async {
    int thisDayCollected = 0;
    await _firestore
        .collection('bills')
        .where('paidon', isEqualTo: searchDate)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        thisDayCollected += element['amountcollected'];
      });
    });
    setState(() {
      todayCollection = thisDayCollected;
    });
//    print('Total collected this day $thisDayCollected');
    return true;
  }

  Future<bool> calculateThisMonthCollected() async {
    int thisMonthCollected = 0;

    try {
      await _firestore
          .collection('monthly/$yearMonthString/payings')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
//          print(element.id);
          thisMonthCollected += element['a'];
        });
      });
    } catch (e) {
      // doc isn't available might be new pack activated
//      print('doc isn\'t available might be new pack activated');
      print(e);
    }

    setState(() {
      monthCollection = thisMonthCollected;
    });

//    print('Total collected this month $thisMonthCollected');
    return true;
  }

  void loadDetails(String searchDate) async {
    setState(() {
      isLoading = true;
    });
    try {
      await getThisMonthSpentMODIFIED(searchDate); // speedy cn
      await calculateThisMonthCollected(); // somewhat speedy
      await calculateThisDayTotal(searchDate); // somewhat speedy
      await getUsersCount(); // hat speedy
      await calculatePercentage();
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var currentDate = DateTime.now();
    String currmon = currentDate.month > 9
        ? '${currentDate.month}'
        : '0${currentDate.month}';
    String currdate =
        currentDate.day > 9 ? '${currentDate.day}' : '0${currentDate.day}';
    yearMonthDateString = '${currentDate.year}-$currmon-$currdate';
    yearMonthString = '${currentDate.year}-$currmon';
    dateString = currentDate.day;
    month = currentDate.month;
    _currentDate = DateTime.now();
    loadDetails(yearMonthDateString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text.rich(
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
                                ),
                              ),
                              packActivated
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () async {
                                        var activationSuccess =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NewMonthActivation(),
                                          ),
                                        );
                                        if (activationSuccess == null ||
                                            activationSuccess == false) return;
                                        await loadDetails(yearMonthDateString);
                                      },
                                      child: Container(
                                        height: 90,
                                        child: Center(
                                          child: Text(
                                            'Activate',
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
                                          color: kSecondaryColor,
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 8,
                              ),
                              packActivated
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  '₹ $monthCollection',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        32,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Collected this month',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          width:
                                                              double.infinity,
                                                          height: 120,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Container(
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  '₹ ${thisMonthSpent + dueFromLastMonth}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        26,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'To be collected',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          width:
                                                              double.infinity,
                                                          height: 80,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 208,
                                                    child: Stack(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .bottomEnd,
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: (percentage /
                                                                  100) *
                                                              208,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                            color:
                                                                kSecondaryColor,
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            '$percentage%',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '₹ $thisMonthSpent',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 22,
                                                          ),
                                                        ),
                                                        Text(
                                                          'This month spent',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: kSecondaryColor,
                                                        width: 3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: kSecondaryColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '₹ $dueFromLastMonth',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 22,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Old months due',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: kPrimaryColor,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 14,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Collections on a Day',
                                  style: TextStyle(
                                    color: kDullFontColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: double.infinity,
                                height: 120,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 12),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$dateString',
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              kMonthList[month - 1],
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 0),
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
                                          child: Center(
                                            child: Text(
                                              '₹ $todayCollection',
                                              style: TextStyle(
                                                fontSize: 28,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: kViewBarColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 16.0, right: 16, top: 16, bottom: 8),
                                child: DottedLine(
                                  direction: Axis.horizontal,
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
                              CalendarCarousel<Event>(
                                showHeaderButton: false,
                                selectedDayButtonColor: kSecondaryColor,
                                selectedDayBorderColor: kSecondaryColor,
                                todayBorderColor: kPrimaryColor,
                                onDayPressed:
                                    (DateTime date, List<Event> events) async {
                                  this.setState(() => _currentDate = date);
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    var currentDate = date;
                                    String currmon = currentDate.month > 9
                                        ? '${currentDate.month}'
                                        : '0${currentDate.month}';
                                    String currdate = currentDate.day > 9
                                        ? '${currentDate.day}'
                                        : '0${currentDate.day}';
                                    String todayDate =
                                        '${currentDate.year}-$currmon-$currdate';
//                                    print(todayDate);
                                    setState(() {
                                      dateString = currentDate.day;
                                      month = currentDate.month;
                                    });
                                    await calculateThisDayTotal(todayDate);
                                  } catch (e) {
                                    print(e);
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                  //Load That day total...
                                },
                                isScrollable: false,
                                daysHaveCircularBorder: false,
                                showOnlyCurrentMonthDate: true,
                                minSelectedDate:
                                    _currentDate.subtract(Duration(days: 360)),
                                maxSelectedDate:
                                    _currentDate.add(Duration(days: 360)),
                                selectedDateTime: _currentDate,
                                weekendTextStyle: TextStyle(
                                  color: Colors.red,
                                ),
                                thisMonthDayBorderColor: Colors.grey,
                                weekFormat: false,
                                height: 420.0,
                                customGridViewPhysics:
                                    NeverScrollableScrollPhysics(),
                                markedDateCustomShapeBorder: CircleBorder(
                                    side: BorderSide(color: kSecondaryColor)),
                                markedDateCustomTextStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w900,
                                ),
                                showHeader: true,
                                headerTextStyle: TextStyle(
                                  fontSize: 18,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w900,
                                ),
                                todayTextStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                                todayButtonColor: kPrimaryColor,
                                selectedDayTextStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                                prevDaysTextStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.pinkAccent,
                                ),
                                inactiveDaysTextStyle: TextStyle(
                                  color: Colors.tealAccent,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'FIBERNET',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            '$fibernetUsers',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 28,
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'TCN',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            '$tcnUsers',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 28,
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: kSecondaryColor,
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
                  )),
            ),
            isLoading ? LoadingScreen('Loading Details') : Container(),
          ],
        ));
  }
}
