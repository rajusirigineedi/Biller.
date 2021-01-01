import 'package:biller/Widgets/HomeScreenWidget/UserBarUnPaidList.dart';
import 'package:biller/Widgets/NoResult.dart';
import 'package:biller/models/AppUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaginateUnPaidUsersAll extends StatefulWidget {
  @override
  _PaginateUnPaidUsersAllState createState() => _PaginateUnPaidUsersAllState();
}

class _PaginateUnPaidUsersAllState extends State<PaginateUnPaidUsersAll> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchData;

  List<DocumentSnapshot> users = [];
  bool initialLoading = false;
  bool bottomLoading = false;

  bool hasMoreDataBelow = true;
  int documentLimit = 5;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();

  getUsers() async {
    if (!hasMoreDataBelow) {
      setState(() {
        bottomLoading = false;
      });
      print('No More Products');
      return;
    }
    if (bottomLoading) {
      print("loading data . please hold on");
      return;
    }
    setState(() {
      bottomLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await _firestore
          .collection("users")
          .where('currentpackpaidon', isEqualTo: '')
          .orderBy('username', descending: false)
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection("users")
          .where('currentpackpaidon', isEqualTo: '')
          .orderBy('username', descending: false)
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .get();
      print(1);
    }

    if (querySnapshot.docs.length < documentLimit) {
      hasMoreDataBelow = false;
    }
    if (querySnapshot.docs.length != 0) {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
      users.addAll(querySnapshot.docs);
    }

    setState(() {
      bottomLoading = false;
    });
  }

  void loadInitialData() async {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getUsers();
      }
    });
    setState(() {
      initialLoading = true;
    });
    hasMoreDataBelow = true;
    users.removeRange(0, users.length);
    lastDocument = null;
    await getUsers();
    setState(() {
      initialLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        initialLoading
            ? Expanded(
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    print("refeshng");
                    await loadInitialData();
                  },
                  child: Column(children: [
                    Expanded(
                      child: users.length == 0
                          ? NoResult()
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                var d = users[index].data();
                                var id = users[index].id;
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
                                return UserBarUnPaidList(user);
                              },
                            ),
                    ),
                    bottomLoading
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container()
                  ]),
                ),
              ),
      ],
    ));
  }
}
