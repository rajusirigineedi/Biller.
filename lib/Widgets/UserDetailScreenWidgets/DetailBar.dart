import 'package:biller/Utils/constants.dart';
import 'package:flutter/material.dart';

class DetailBar extends StatelessWidget {
  final String label;
  final String value;
  final String warn;
  DetailBar(this.label, this.value, [this.warn]);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 34, vertical: 16),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: (this.warn == null) ? kPrimaryColor : Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color:
                  (this.warn == null) ? kDimBackgroundColor : kSecondaryColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: (this.warn == null) ? kPrimaryColor : kSecondaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
