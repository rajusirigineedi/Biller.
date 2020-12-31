import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/UserDetailScreenWidgets/DetailBar.dart';
import 'package:biller/models/AppUser.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class UpgradePackFragment extends StatefulWidget {
  final AppUser user;
  final Function function;
  UpgradePackFragment(this.user, this.function);

  @override
  _UpgradePackFragmentState createState() => _UpgradePackFragmentState();
}

class _UpgradePackFragmentState extends State<UpgradePackFragment> {
  AppUser user;
  bool isExtension = true;
  String amountEntered = '';
  String summary = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Container(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 8),
                      child: Text(
                        'Enter Amount',
                        style: TextStyle(
                          color: kDullFontColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        node.nextFocus();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 34, vertical: 16),
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
                                onChanged: (value) {
                                  amountEntered = value;
                                },
                                onEditingComplete: () => node.nextFocus(),
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Enter Amount',
                                    fillColor: kPrimaryColor,
                                    hintStyle: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: kDimBackgroundColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        node.nextFocus();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 34, vertical: 16),
                        child: Row(
                          children: [
                            Text(
                              '#',
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
                                onChanged: (value) {
                                  summary = value;
                                },
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Summary',
                                    fillColor: kPrimaryColor,
                                    hintStyle: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: kDimBackgroundColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExtension = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 18),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    'Extension',
                                    style: TextStyle(
                                      color: isExtension
                                          ? Colors.white
                                          : kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: isExtension
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
                                  isExtension = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 18),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    'Change Pack',
                                    style: TextStyle(
                                      color: isExtension
                                          ? kPrimaryColor
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: isExtension
                                      ? kDimBackgroundColor
                                      : kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              print("clicked");
              if (amountEntered != null) {
                if (amountEntered == '') return;
                if (summary == '') return;
                if (summary == null) return;
                try {
                  int val = int.parse(amountEntered.trim());
                  if (val <= 0) return;
                  print(val);
                  await widget.function(val, summary, isExtension);
                } catch (e) {
                  print(e);
                  print("Entered Amount is invalid");
                }
              }
            },
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 60,
                    child: Center(
                      child: Icon(
                        LineIcons.paper_plane,
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
                        'Upgrade Pack',
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
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
