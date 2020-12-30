import 'package:biller/Utils/StaticUser.dart';
import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/UserDetailScreenWidgets/DetailBar.dart';
import 'package:biller/models/AppUser.dart';
import 'package:flutter/material.dart';

class UserDetailsFragment extends StatefulWidget {
  final AppUser user;
  final Function function;
  UserDetailsFragment(this.user, this.function);

  @override
  _UserDetailsFragmentState createState() => _UserDetailsFragmentState();
}

class _UserDetailsFragmentState extends State<UserDetailsFragment> {
  AppUser user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
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
                    DetailBar('Due', '₹ ${user.totaldue}', 'warn'),
                    DetailBar('Phone Number', user.phone),
                    DetailBar('Adress :', ''),
                    Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 34, vertical: 16),
                        child: Center(
                          child: Text(
                            user.address,
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
//                    Padding(
//                      padding: EdgeInsets.only(left: 8.0),
//                      child: Text(
//                        'Pack Details',
//                        style: TextStyle(
//                          color: kDullFontColor,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 16,
//                        ),
//                      ),
//                    ),
//                    DetailBar('Current Pack', '₹ ${user.currentpackamount}'),
//                    (user.currentpackpaidon == '' ||
//                            user.currentpackpaidon == null)
//                        ? Container()
//                        : DetailBar('Paid On', user.currentpackpaidon),
//                    DetailBar('Summary :', ''),
//                    Padding(
//                      padding: EdgeInsets.only(top: 14),
//                      child: Container(
//                        padding:
//                            EdgeInsets.symmetric(horizontal: 34, vertical: 16),
//                        child: Center(
//                          child: Text(
//                            user.currentpacksummary,
//                            style: TextStyle(
//                              color: kPrimaryColor,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 16,
//                            ),
//                          ),
//                        ),
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(8.0),
//                          color: kDimBackgroundColor,
//                        ),
//                      ),
//                    ),
                    (currentUserIsAdmin)
                        ? GestureDetector(
                            onTap: () async {
                              print("clicked");
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Delete ?',
                                      style: TextStyle(
                                        color: kSecondaryColor,
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Are you sure to delete ${user.username} ?',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      await widget.function();
                                                    },
                                                    child: Container(
                                                      height: 48,
                                                      child: Center(
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        color: kSecondaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      height: 48,
                                                      child: Center(
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        color: kPrimaryColor,
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
                                    actions: <Widget>[],
                                  );
                                },
                              );
//                        await widget.function();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 14),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 34, vertical: 16),
                                child: Center(
                                  child: Text(
                                    'Delete Account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: kSecondaryColor,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
