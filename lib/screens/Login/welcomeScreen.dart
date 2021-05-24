import 'package:college_project_doctor/constants/colors.dart';
import 'package:college_project_doctor/constants/styles.dart';
import 'package:college_project_doctor/screens/bottomNavigation/bottomNavigation.dart';
import 'package:college_project_doctor/helper/helperFunction.dart';
import 'package:college_project_doctor/screens/register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User user;
  var status;
  bool isVerified = false;
  Future<bool> loginUser(
    phoneNumber,
    context,
  ) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        phoneNumber: "+91${phoneNumber}",
        verificationCompleted: (AuthCredential credentials) async {
          Navigator.of(context).pop();
          UserCredential result = await _auth.signInWithCredential(credentials);
          User user = result.user;
          if (user != null) {
            HelperFunctions.saveUserUIDSharedPreference(user.uid);
            setState(() {
              loading = false;
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Bottom_Navigation()),
            );
          }
        },
        verificationFailed: (FirebaseAuthException authException) {
          setState(() {
            status = '${authException.message}';

            print("Error message: " + status);
            if (authException.message.contains('not authorized'))
              status = 'Something has gone wrong, please try later';
            else if (authException.message.contains('Network'))
              status = 'Please check your internet connection and try again';
            else
              status = 'Something has gone wrong, please try later';
          });
        },
        codeSent: (String verificationId, [int forceSendingToken]) {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return AlertDialog(
                  insetPadding: EdgeInsets.symmetric(vertical: 100),
                  title: Text('OTP'),
                  content: Column(
                    children: [
                      TextField(
                        controller: _codeController,
                      )
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      color: blue,
                      child: Text("confirm"),
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credentials =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: code); //need to change to code
                        UserCredential result =
                            await _auth.signInWithCredential(credentials);
                        user = result.user;
                        if (user != null) {
                          HelperFunctions.saveUserUIDSharedPreference(user.uid);
                          print(
                              "this ${HelperFunctions.getUserUIDSharedPreference()}");
                          setState(() {
                            loading = false;
                          });
                          HelperFunctions.saveUserNameSharedPreference(
                                  _nameController.text)
                              .then((value) =>
                                  print("stored in sharedpreference $value"))
                              .catchError((error) =>
                                  print("error from shared preferance $error"));
                          HelperFunctions.saveUserLoggedInSharedPreference(
                              true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Bottom_Navigation()),
                          );
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: textStyle,
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: boxDecorationStyle,
                      height: 60.0,
                      child: TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          // setState(() {
                          //   value1 = value;
                          // });

//
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.black54,
                          ),
                          hintText: "Enter your name",
                          hintStyle: hintTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Mobile No',
                      style: textStyle,
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: boxDecorationStyle,
                      height: 60.0,
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.black54,
                          ),
                          hintText: "Enter your phone Number",
                          hintStyle: hintTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            loading = true;
                          });

                          final phone = _phoneController.text.trim();
                          loginUser(phone, context);
                          if (isVerified) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Register()));
                          } else {
                            print("no");
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              width: size.width / 2.5,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Log In",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Register()));
                              },
                              child: Container(
                                width: size.width / 2.5,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
