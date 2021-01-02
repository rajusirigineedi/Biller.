import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/LodingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomeScreen.dart';
import 'LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  String usermail = '';
  String password = '';

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(child: Container()),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset('assets/billerlogo.png'),
                                ),
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
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                          AuthTextFields(LineIcons.user, 'Enter mail',
                              mailController, false),
                          AuthTextFields(LineIcons.key, 'Enter Password',
                              passwordController, true),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    usermail = mailController.value.text;
                    password = passwordController.value.text;

                    if (usermail == null || password == null) return;
                    if (usermail == '' || password == '') return;

                    usermail = usermail.trim();

                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: usermail, password: password);
                      await _firestore
                          .collection('staff')
                          .doc(newUser.user.uid)
                          .set({'isadmin': false, 'email': usermail});
                      if (newUser != null) {
//                        print(newUser);
//                        print('Creation successful');
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('isAdmin', false);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                        Navigator.pop(context);
                      }
//                      print(newUser);
                    } catch (e) {
                      print(e);
//                      print("error creating");
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Create Staff',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: kPrimaryColor,
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
              ? LoadingScreen('Creating Staff\nPlease Wait')
              : Container(),
        ],
      ),
    );
  }
}
