import 'dart:ui';

import 'package:biller/Utils/constants.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final label;
  LoadingScreen(this.label);
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        color: Colors.black.withOpacity(0),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor: kSecondaryColor,
                  strokeWidth: 8,
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
