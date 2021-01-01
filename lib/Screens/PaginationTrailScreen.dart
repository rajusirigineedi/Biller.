import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/HomeScreenWidget/SearchBar.dart';
import 'package:biller/Widgets/HomeScreenWidget/UserBarUserList.dart';
import 'package:biller/Widgets/NoResult.dart';
import 'package:biller/models/AppUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaginationTrailScreen extends StatefulWidget {
  @override
  _PaginationTrailScreenState createState() => _PaginationTrailScreenState();
}

class _PaginationTrailScreenState extends State<PaginationTrailScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchData;

  bool isSearching = false;

  List<DocumentSnapshot> users = [];
  bool initialLoading = false;
  bool bottomLoading = false;

  bool hasMoreDataBelow = true;
  int documentLimit = 10;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();
  ScrollController _searchScrollController = ScrollController();

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
          .orderBy('username', descending: false)
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection("users")
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

  getSearchedUsers(String searchWord) async {
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
    print("targetting");
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await _firestore
          .collection("users")
          .orderBy('username')
          .startAt([searchWord])
          .endAt([searchWord + '\uf8ff'])
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection("users")
          .orderBy('username')
          .startAt([searchWord])
          .endAt([searchWord + '\uf8ff'])
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
      isSearching = false;
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

  void loadInitialSearchData(String searchWord) async {
    if (searchWord == '') {
      return loadInitialData();
    }
    _searchScrollController.addListener(() {
      double maxScroll = _searchScrollController.position.maxScrollExtent;
      double currentScroll = _searchScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        print("it is claad??");
        getSearchedUsers(searchWord);
      }
    });
    setState(() {
      isSearching = true;
      initialLoading = true;
    });
    hasMoreDataBelow = true;
    users.removeRange(0, users.length);
    lastDocument = null;
    await getSearchedUsers(searchWord);
    setState(() {
      initialLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInitialData();
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
            SearchBar(loadInitialSearchData),
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
                        (isSearching)
                            ? Expanded(
                                child: users.length == 0
                                    ? NoResult()
                                    : ListView.builder(
                                        controller: _searchScrollController,
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
                                          return UserBarUserList(user);
                                        },
                                      ),
                              )
                            : Expanded(
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
                                          return UserBarUserList(user);
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
        )),
      ),
    );
  }
}
