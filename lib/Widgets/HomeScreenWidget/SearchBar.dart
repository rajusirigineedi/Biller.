import 'package:biller/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class SearchBar extends StatefulWidget {
  final Function function;
  SearchBar(this.function);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool isExpanded = false;
  String searchWord;
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: isExpanded
          ? GestureDetector(
              onTap: () {
                focusNode.requestFocus();
              },
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        height: 48,
                        child: TextField(
                          onChanged: (value) {
                            searchWord = value;
                          },
                          focusNode: focusNode,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Search here',
                            hintStyle: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (searchWord != null) {
                                if (searchWord == '') return;
                                searchWord = searchWord.trim();
                                try {
                                  int convertible = int.parse(searchWord);
                                  widget.function(searchWord.toLowerCase());
                                } catch (e) {
                                  print(e);
                                  if (searchWord.length >= 4 &&
                                      searchWord.substring(0, 4) == 'dsnw') {
                                    widget.function(searchWord.toLowerCase());
                                  } else {
                                    widget.function(
                                        searchWord.toLowerCase(), true);
                                  }
                                }
//                                print("Search Bar in $searchWord");
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                LineIcons.search,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = false;
                              });
                              widget.function('', true);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                LineIcons.close,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: kViewBarColor,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Text.rich(
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
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = true;
                      focusNode.requestFocus();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    height: 48,
                    child: Center(
                      child: Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: kViewBarColor,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
