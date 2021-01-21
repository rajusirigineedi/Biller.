import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CSVWriter extends StatefulWidget {
  @override
  _CSVWriterState createState() => _CSVWriterState();
}

class _CSVWriterState extends State<CSVWriter> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  Future<bool> generateData(listOfData) async {
    String csv = const ListToCsvConverter().convert(listOfData);

    /// Write to a file
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "/thisMonthBill.csv";
    print('>>>>>>>>>>>>>>>>>>>>>>>');
    print(pathOfTheFileToWrite);
    File file = await File(pathOfTheFileToWrite);
    file.writeAsString(csv);
    print("succ");

    return true;
  }

  Future<String> getListOfData() async {
    List<List<String>> totalDoc = [];

    await _firestore.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
//        print(element.id);
//        element['val'];
//        print(element['username']);
//        print(element['serial']);
//        print(element['isfibernet']);
//        print(element['phone']);
//        print(element['currentpackamount']);
//        print(element['currentpacksummary']);
//        print(element['currentpackpaidon']);
//        print(element['totaldue']);
//        print(element['address']);

        print(element.id);

        String username = element['username'];
        String serial = element['serial'];
        String isfibernet = element['isfibernet'] ? 'Fibernet' : 'TCN';
        String phone = element['phone'];
        String address = element['address'].replaceAll(",", " | ");
        int currentPackAmount = element['currentpackamount'];
        String currentPackSummary =
            element['currentpacksummary'].replaceAll(",", " | ");
        String currentPackPaidOn = element['currentpackpaidon'];
        int totalDue = element['totaldue'];
        currentPackPaidOn =
            currentPackPaidOn == '' ? 'Not Paid' : currentPackPaidOn;

        List<String> doclist = [
          username,
          serial,
          isfibernet,
          phone,
          address,
          '$currentPackAmount',
          currentPackSummary,
          currentPackPaidOn,
          '$totalDue'
        ];

        // get last transactions
        totalDoc.add(doclist);
      });
    });
    print(totalDoc);
    await generateData(totalDoc);
    return '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListOfData();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
