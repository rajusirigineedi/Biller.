import 'dart:async';

import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/HomeScreenWidget/PaidBar.dart';
import 'package:biller/Widgets/HomeScreenWidget/UserBarPaidList.dart';
import 'package:biller/Widgets/HomeScreenWidget/UserBarUnPaidList.dart';
import 'package:biller/Widgets/HomeScreenWidget/UserBarUserList.dart';
import 'package:biller/Widgets/NoResult.dart';
import 'package:biller/models/AppUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class PaginateAllUsers extends StatelessWidget {
  PaginateAllUsers();
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    PaginateRefreshedChangeListener refreshChangeListener =
        PaginateRefreshedChangeListener();
    return RefreshIndicator(
      color: kSecondaryColor,
      backgroundColor: kPrimaryColor,
      strokeWidth: 3,
      child: PaginateFirestore(
        itemsPerPage: 10,
        emptyDisplay:
            NoResult(), // since if empty Results got for all users list.. Then list is empty
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (index, context, documentSnapshot) {
          var d = documentSnapshot.data();
          var id = documentSnapshot.id;
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
        query: _firestore
            .collection("users")
            .orderBy('username', descending: false),
        listeners: [
          refreshChangeListener,
        ],
      ),
      onRefresh: () async {
        print("refreshed from paginate all users");
        refreshChangeListener.refreshed = true;
      },
    );
  }
}

class PaginateAllUsersPaid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    PaginateRefreshedChangeListener refreshChangeListener =
        PaginateRefreshedChangeListener();
    return RefreshIndicator(
      color: kSecondaryColor,
      backgroundColor: kPrimaryColor,
      strokeWidth: 3,
      child: PaginateFirestore(
        itemsPerPage: 10,
        emptyDisplay: NoResult(),
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (index, context, documentSnapshot) {
          var d = documentSnapshot.data();
          var id = documentSnapshot.id;
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
          return UserBarPaidList(user);
        },
        query: _firestore
            .collection("users")
            .where('currentpackpaidon', isNotEqualTo: '')
            .orderBy('currentpackpaidon', descending: false)
            .orderBy('username', descending: false),
        listeners: [
          refreshChangeListener,
        ],
      ),
      onRefresh: () async {
        print("refreshed");
        refreshChangeListener.refreshed = true;
      },
    );
  }
}

class PaginateAllUsersUnPaid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    PaginateRefreshedChangeListener refreshChangeListener =
        PaginateRefreshedChangeListener();
    return RefreshIndicator(
      color: kSecondaryColor,
      backgroundColor: kPrimaryColor,
      strokeWidth: 3,
      child: PaginateFirestore(
        itemsPerPage: 10,
        emptyDisplay: NoResult(),
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (index, context, documentSnapshot) {
          var d = documentSnapshot.data();
          var id = documentSnapshot.id;
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
        query: _firestore
            .collection("users")
            .where('currentpackpaidon', isEqualTo: '')
            .orderBy('username', descending: false),
        listeners: [
          refreshChangeListener,
        ],
      ),
      onRefresh: () async {
        print("refreshed");
        refreshChangeListener.refreshed = true;
      },
    );
  }
}
