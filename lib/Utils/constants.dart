import 'package:biller/models/AppUser.dart';
import 'package:flutter/material.dart';

final kPrimaryColor = Color(0xff240088);
final kSecondaryColor = Color(0xffff5400);
//final kDimBackgroundColor = Color(0xFFF9F9F9);
final kDimBackgroundColor = Color(0xffeae9f7);
final kDullFontColor = Color(0xFF7C7C7C);
final kViewBarColor = Color(0xfff7f7f7);

final kFontStyleForFibernet = TextStyle(
  fontSize: 20,
  color: kPrimaryColor,
  fontWeight: FontWeight.w900,
);

final kFontStyleForTcn = TextStyle(
  fontSize: 20,
  color: kSecondaryColor,
  fontWeight: FontWeight.w900,
);

final kDateColor = Color(0xFF00C4FF);
final kFontStyleForUsername = TextStyle(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.w900,
);
final kFontStyleForConnectionType = TextStyle(
  fontSize: 20,
  color: Color(0xFF7C7C7C),
  fontWeight: FontWeight.w900,
);
final kFontStyleForNormalText = TextStyle(
  fontSize: 14,
  color: Color(0xFF7C7C7C),
);

List<String> kMonthList = [
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MAY',
  'JUN',
  'JUL',
  'AUG',
  'SEP',
  'OCT',
  'NOV',
  'DEC',
];

enum SearchType { all, name, serial }

String getPaymentMessage(AppUser user, String msg) {
  String message =
      'Dear ${user.username},\n$msg.\nThank You\nBalla Devendra, 9666519407\nSai Cable Network,Rameshwaram';
  return message;
}
