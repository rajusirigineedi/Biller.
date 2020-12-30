import 'package:biller/Widgets/HomeScreenWidget/PaidBar.dart';
import 'package:biller/Widgets/HomeScreenWidget/SearchBar.dart';
import 'package:biller/Widgets/HomeScreenWidget/UserBarUnPaidList.dart';
import 'package:biller/Widgets/NoResult.dart';
import 'package:biller/models/AppUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UnPaidListScreen extends StatefulWidget {
  @override
  _UnPaidListScreenState createState() => _UnPaidListScreenState();
}

class _UnPaidListScreenState extends State<UnPaidListScreen> {
  bool searchClicked = false;
  String searchWord;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot> _firestoreStream;

  void searchData(String searchWord) {
    setState(() {
      this.searchWord = searchWord;
      if (searchWord == '' || searchWord == null) {
        _firestoreStream = _firestore
            .collection("users")
            .where('currentpackpaidon', isEqualTo: '')
            .orderBy('username', descending: false)
            .snapshots();
      } else {
        print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
        print(searchWord);
        bool usernamequery = true;
        if (usernamequery) {
          _firestoreStream = _firestore
              .collection("users")
              .orderBy('username')
              .startAt([searchWord]).endAt([searchWord + '\uf8ff']).snapshots();
        } else {
          _firestoreStream = _firestore
              .collection("users")
              .orderBy('serial')
              .startAt([searchWord]).endAt([searchWord + '\uf8ff']).snapshots();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    searchData('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SearchBar(searchData),
            Expanded(
              child: StreamBuilder(
                  stream: _firestoreStream,
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
                        return (snapshot.data.documents.length == 0)
                            ? NoResult(searchWord: searchWord)
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  var d = snapshot.data.documents[index];
                                  var id = d.documentID;

                                  AppUser user = new AppUser(
                                      d['username'],
                                      d['phone'],
                                      d['serial'],
                                      d['isfibernet'],
                                      d['address'],
                                      d['totaldue'],
                                      d['currentpackamount'],
                                      d['currentpacksummary'],
                                      d['currentpackpaidon'],
                                      id);
                                  if (d['currentpackpaidon'] != '')
                                    return PaidBar(user);
                                  return UserBarUnPaidList(user);
                                });
                    }
                  }),
            ),
          ],
        )),
      ),
    );
  }
}
