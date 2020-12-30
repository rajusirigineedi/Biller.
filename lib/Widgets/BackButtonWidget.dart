import 'package:biller/Utils/constants.dart';
import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 26, top: 16, bottom: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Center(
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: kDimBackgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
