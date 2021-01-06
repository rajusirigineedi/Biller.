import 'package:biller/Utils/constants.dart';
import 'package:biller/Widgets/BackButtonWidget.dart';
import 'package:biller/Widgets/LodingScreen.dart';
import 'package:biller/models/AppUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser user;
  EditProfileScreen(this.user);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isfibernet;
  String userName;
  String serialNumber;
  String phoneNumber;
  String address;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<bool> validateAllFields() async {
    if (userName == '' ||
        serialNumber == '' ||
        phoneNumber == '' ||
        address == '') return false;
    if (userName == null ||
        serialNumber == null ||
        phoneNumber == null ||
        address == null) return false;
    userName = userName.trim().toLowerCase();
    serialNumber = serialNumber.trim().toLowerCase();
    phoneNumber = phoneNumber.trim();
    address = address.trim();
    if (userName == '' ||
        serialNumber == '' ||
        phoneNumber == '' ||
        address == '') return false;
    return true;
  }

  Future<bool> editUser() async {
    setState(() {
      isLoading = true;
    });
    bool isSuccess = await validateAllFields();
    if (isSuccess) {
      //load pack details
      try {
        int fibernetUserCount;
        int tcnUserCount;
        await _firestore
            .collection('packs')
            .doc('basepack')
            .get()
            .then((value) {
          fibernetUserCount = value['fcount'];
          tcnUserCount = value['tcount'];
        });
        var batch = _firestore.batch();
        if (widget.user.isfibernet != isfibernet) {
          if (isfibernet) {
            fibernetUserCount += 1;
            tcnUserCount -= 1;
          } else {
            tcnUserCount += 1;
            fibernetUserCount -= 1;
          }
          await batch.update(
              _firestore.collection('packs').doc('basepack'), <String, dynamic>{
            'fcount': fibernetUserCount,
            'tcount': tcnUserCount,
          });
        }
        await batch.update(
            _firestore.collection('users').doc(widget.user.userid),
            <String, dynamic>{
              'username': userName,
              'phone': phoneNumber,
              'serial': serialNumber,
              'isfibernet': isfibernet,
              'address': address,
            });

        await batch.commit();
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      } catch (e) {
        print(e);
        //TODO: snackbar saying something went wrong
      }
      setState(() {
        isLoading = false;
      });
      return true;
    } else {
      //TODO: implement a snack bar saying Enter required values
      // like name, phone, serial, at least village
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isfibernet = widget.user.isfibernet;
    userName = widget.user.username;
    phoneNumber = widget.user.phone;
    address = widget.user.address;
    serialNumber = widget.user.serial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                BackButtonWidget(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text.rich(
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
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Edit Customer Details',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                          FullLengthField(LineIcons.user, 'Enter Username',
                              widget.user.username, (value) {
                            userName = value;
                          }),
                          FullLengthField(LineIcons.sort_alpha_desc,
                              'Serial Number', widget.user.serial, (value) {
                            serialNumber = value;
                          }),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isfibernet = true;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 34, vertical: 18),
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          'AP Fibernet',
                                          style: TextStyle(
                                            color: isfibernet
                                                ? Colors.white
                                                : kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: isfibernet
                                            ? kPrimaryColor
                                            : kDimBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isfibernet = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 34, vertical: 18),
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          'TCN Digital',
                                          style: TextStyle(
                                            color: isfibernet
                                                ? kPrimaryColor
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: isfibernet
                                            ? kDimBackgroundColor
                                            : kSecondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FullLengthField(LineIcons.phone, 'Phone Number',
                              widget.user.phone, (value) {
                            phoneNumber = value;
                          }),
                          FullLengthField(
                              LineIcons.globe, 'Address', widget.user.address,
                              (value) {
                            address = value;
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
//                    print("Clicked Confirming");
                    await editUser();
//                    print(userName);
//                    print(serialNumber);
//                    print(phoneNumber);
//                    print(address);
//                    print(isfibernet);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: kSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? LoadingScreen('Editing customer Details\nPlease Wait')
              : Container(),
        ],
      ),
    );
  }
}

class FullLengthField extends StatelessWidget {
  final icontype;
  final label;
  final initval;
  final function;
  final focusNode = FocusNode();
  FullLengthField(this.icontype, this.label, this.initval, this.function);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller =
        new TextEditingController(text: initval);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          focusNode.requestFocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 34, vertical: 18),
          width: double.infinity,
          child: Row(
            children: [
              Icon(
                icontype,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: function,
                  focusNode: focusNode,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: label,
                    fillColor: kPrimaryColor,
                    hintStyle: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: kDimBackgroundColor,
          ),
        ),
      ),
    );
  }
}
