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

class PaginateSearchedUsersSerial extends StatelessWidget {
  final String searchWord;
  PaginateSearchedUsersSerial(this.searchWord);
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    PaginateRefreshedChangeListener refreshChangeListener =
        PaginateRefreshedChangeListener();
    print('-------------- I searched this $searchWord');
    return RefreshIndicator(
      color: kSecondaryColor,
      backgroundColor: kPrimaryColor,
      strokeWidth: 3,
      child: PaginateFirestore(
        itemsPerPage: 10,
        emptyDisplay: NoResult(searchWord: 'searched'),
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
            .orderBy('serial')
            .startAt([searchWord]).endAt([searchWord + '\uf8ff']),
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

class PaginateSearchedUsersSerialPaid extends StatelessWidget {
  final String searchWord;
  PaginateSearchedUsersSerialPaid(this.searchWord);
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    PaginateRefreshedChangeListener refreshChangeListener =
        PaginateRefreshedChangeListener();
    print('-------------- I searched this $searchWord');
    return RefreshIndicator(
      color: kSecondaryColor,
      backgroundColor: kPrimaryColor,
      strokeWidth: 3,
      child: PaginateFirestore(
        itemsPerPage: 10,
        emptyDisplay: NoResult(searchWord: 'searched'),
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
          if (d['currentpackpaidon'] == '') return PaidBar(user);
          return UserBarPaidList(user);
        },
        query: _firestore
            .collection("users")
            .orderBy('serial')
            .startAt([searchWord]).endAt([searchWord + '\uf8ff']),
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

class PaginateSearchedUsersSerialUnPaid extends StatelessWidget {
  final String searchWord;
  PaginateSearchedUsersSerialUnPaid(this.searchWord);
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    PaginateRefreshedChangeListener refreshChangeListener =
        PaginateRefreshedChangeListener();
    print('-------------- I searched this $searchWord');
    return RefreshIndicator(
      color: kSecondaryColor,
      backgroundColor: kPrimaryColor,
      strokeWidth: 3,
      child: PaginateFirestore(
        itemsPerPage: 10,
        emptyDisplay: NoResult(searchWord: 'searched'),
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
          if (d['currentpackpaidon'] != '') return PaidBar(user);
          return UserBarUnPaidList(user);
        },
        query: _firestore
            .collection("users")
            .orderBy('serial')
            .startAt([searchWord]).endAt([searchWord + '\uf8ff']),
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
