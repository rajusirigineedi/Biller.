import 'package:biller/Screens/AuthScreens/SignUpScreen.dart';
import 'package:biller/Screens/HomeScreen.dart';
import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/HalfAndFullFields.dart';
import 'package:biller/Widgets/LodingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    if (usermail == 'rellib' && password == 'biller') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                    }
                    usermail = usermail.trim();

                    try {
                      final currUser = await _auth.signInWithEmailAndPassword(
                          email: usermail, password: password);
                      if (currUser != null) {
                        bool isAdmin = false;
                        await _firestore
                            .collection('staff')
                            .doc(currUser.user.uid)
                            .get()
                            .then((value) {
                          isAdmin = value['isadmin'];
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('isAdmin', isAdmin);
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ));
                        Navigator.pop(context);
                      } else {
//                        print("Something went wrong ! Please try Again");
                      }
                    } catch (e) {
                      print(e);
//                      print("Invalid Username or Password");
                      //TODO: snackbar
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
                                'Login',
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
                )
              ],
            ),
          ),
          isLoading ? LoadingScreen('Logging In\nPlease Wait') : Container(),
        ],
      ),
    );
  }
}

class AuthTextFields extends StatelessWidget {
  final iconfield;
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final focusNode = FocusNode();

  AuthTextFields(this.iconfield, this.label, this.controller, this.isPassword);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          focusNode.requestFocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 34, vertical: 18),
          width: double.infinity,
          child: Row(
            children: [
              Icon(
                iconfield,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  obscureText: isPassword,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: label,
                    fillColor: kPrimaryColor,
                    hintStyle: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
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
    );
  }
}
