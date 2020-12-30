import 'package:biller/Widgets/UserDetailScreenWidgets/DueAndPayWidget.dart';
import 'package:biller/models/AppUser.dart';
import 'package:biller/models/Bill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DueBillsFragment extends StatefulWidget {
  final AppUser user;
  DueBillsFragment(this.user);
  @override
  _DueBillsFragmentState createState() => _DueBillsFragmentState();
}

class _DueBillsFragmentState extends State<DueBillsFragment> {
  AppUser user;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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
            child: FutureBuilder(
                future: _firestore
                    .collection("bills")
                    .where('userid', isEqualTo: user.userid)
                    .orderBy('paidon', descending: true)
                    .get(),
                builder: (context, snapshot) {
                  print(">>>>>>>>invoking ");
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      if (snapshot.data == null) {
                        return Text("No Data");
                      }
                      return new ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            var d = snapshot.data.documents[index];
                            var id = d.documentID;
                            Bill bill = Bill(d['topay'], d['paid'], d['due'],
                                d['paidon'], d['summary'], d['userid']);
                            if (d['due'] != 0)
                              return DueAndPayWidgets(user, bill);
                            return Container();
                          });
                  }
                }),
          ),
        ],
      ),
    );
  }
}
