import 'package:biller/Screens/AuthScreens/LoginScreen.dart';
import 'package:biller/Screens/CreateUserScreen.dart';
import 'package:biller/Utils/StaticUser.dart';
import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/HomeScreenWidget/SearchBar.dart';
import 'package:biller/Widgets/HomeScreenWidget/UserBarUserList.dart';
import 'package:biller/Widgets/NoResult.dart';
import 'package:biller/models/AppUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:line_icons/line_icons.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot> _firestoreStream;
  String searchWord;

  Stream<QuerySnapshot> searchData(String searchWord) {
    setState(() {
      this.searchWord = searchWord;
      if (searchWord == '' || searchWord == null) {
        _firestoreStream = _firestore
            .collection("users")
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

//        _firestoreStream = _firestore
//            .collection("users")
//            .orderBy('username')
//            .where('username', isGreaterThanOrEqualTo: searchWord)
//            .snapshots();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
                                  return UserBarUserList(user);
                                });
                    }
                  }),
            ),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(LineIcons.user_plus),
        backgroundColor: kSecondaryColor,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        onPressed: () async {
//          await _auth.signOut();
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => LoginScreen(),
//            ),
//          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateUserScreen(),
            ),
          );
        },
      ),
    );
  }
}
