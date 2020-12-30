import 'package:biller/Screens/ConfirmPaymentScreen.dart';
import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/UserDetailScreenWidgets/DetailBar.dart';
import 'package:biller/models/AppUser.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MonthlyBillFragment extends StatefulWidget {
  AppUser user;
  MonthlyBillFragment(this.user);
  @override
  _MonthlyBillFragmentState createState() => _MonthlyBillFragmentState();
}

class _MonthlyBillFragmentState extends State<MonthlyBillFragment> {
  AppUser user;
  bool currentPackPaid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
    currentPackPaid =
        !(user.currentpackpaidon == '' || user.currentpackpaidon == null);
  }

  @override
  Widget build(BuildContext context) {
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
                    DetailBar('Due', '₹ ${user.totaldue}', 'warn'),
                    SizedBox(
                      height: 14,
                    ),
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
                    DetailBar('Current Pack', '₹ ${user.currentpackamount}'),
                    currentPackPaid
                        ? Container()
                        : DetailBar('Total To Pay Now',
                            '₹ ${user.currentpackamount + user.totaldue}'),
                    currentPackPaid
                        ? DetailBar('Paid On', user.currentpackpaidon)
                        : Container(),
                    DetailBar('Summary :', ''),
                    Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 34, vertical: 16),
                        child: Center(
                          child: Text(
                            user.currentpacksummary,
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
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
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () async {
              if (currentPackPaid) {
                // TODO: implement bill printing page
              } else {
                //TODO: call confirm page
                bool isSuccess = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmPaymentScreen(user),
                  ),
                );
                if (isSuccess == null || isSuccess == false) {
                } else {
                  Navigator.pop(context);
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
                        currentPackPaid
                            ? LineIcons.print
                            : LineIcons.paper_plane,
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
                        currentPackPaid ? 'Print Bill' : 'Confirm',
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
