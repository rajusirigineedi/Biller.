import 'package:biller/Utils/constants.dart';
import 'package:flutter/material.dart';

class NoResult extends StatelessWidget {
  const NoResult({
    Key key,
    @required this.searchWord,
  }) : super(key: key);

  final String searchWord;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: (searchWord == '' || searchWord == null)
                  ? Image.asset('assets/empty.png')
                  : Image.asset('assets/notfound.png'),
            ),
            (searchWord == '' || searchWord == null)
                ? Text(
                    "Empty",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "No results found",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
