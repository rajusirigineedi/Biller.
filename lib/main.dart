import 'package:biller/Screens/AuthScreens/LoginScreen.dart';
import 'package:biller/Utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      return MaterialApp(
        title: 'Biller.',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
