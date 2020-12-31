import 'package:biller/Utils/constants.dart';
import 'package:flutter/material.dart';

class CustomLengthField extends StatelessWidget {
  final icontype;
  final label;
  final function;
  final focusNode = FocusNode();
  CustomLengthField(this.icontype, this.label, this.function);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          focusNode.requestFocus();
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 34, vertical: 18),
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(
                      icontype,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        onChanged: function,
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
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class FullLengthField extends StatelessWidget {
  final icontype;
  final label;
  final function;
  final focusNode = FocusNode();
  FullLengthField(this.icontype, this.label, this.function);

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
                icontype,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  onChanged: function,
                  focusNode: focusNode,
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
