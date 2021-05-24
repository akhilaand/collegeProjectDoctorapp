import 'package:college_project_doctor/constants/colors.dart';
import 'package:college_project_doctor/constants/styles.dart';
import 'package:college_project_doctor/screens/bottomNavigation/bottomNavigation.dart';
import 'package:college_project_doctor/helper/helperFunction.dart';
import 'package:college_project_doctor/services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showSpinner = false;
  String downloadedUrl;
  File selectedImage;
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  User user;
  String status;
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

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Bottom_Navigation()),
            );
            setState(() {
              showSpinner = false;
            });
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
          setState(() {
            showSpinner = false;
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
                            showSpinner = false;
                          });
                          HelperFunctions.saveUserNameSharedPreference(
                                  _nameController.text)
                              .then((value) =>
                                  print("stored in sharedpreference $value"))
                              .catchError((error) =>
                                  print("error from shared preferance $error"));
                          HelperFunctions.saveUserLoggedInSharedPreference(
                              true);
                          await uploadImage().catchError((error) {
                            print("error from uploading doctor image $error");
                          });
                          Map<String, String> doctorDetailMap = {
                            "name": _nameController.text,
                            "specializedArea": _speialisedController.text,
                            "downloadUrl": downloadedUrl,
                            "doctorUid": user.uid
                          };
                          _dataBaseMethods.uploadDoctorDetail(
                              doctorDetailMap, user.uid);
                          Navigator.push(
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

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _speialisedController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () async {
                        await selectFile();
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        child: selectedImage == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 50,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Image.file(
                                  selectedImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        // IconButton(
                        //     icon: Center(
                        //       child: selectedImage == null
                        //           ? Icon(
                        //               Icons.camera_alt,
                        //               size: 50,
                        //             )
                        //           : selectedImage,
                        //     ),
                        //     onPressed: () async {
                        //       await selectFile();
                        //     }),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
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
                    'Specialized Field',
                    style: textStyle,
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: boxDecorationStyle,
                    height: 60.0,
                    child: TextField(
                      controller: _speialisedController,
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
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
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
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });

                        final phone = _phoneController.text.trim();
                        loginUser(phone, context);
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
    );
  }

  Future selectFile() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(image.path);
    });
  }

  Future uploadImage() async {
    print("pressed");
    if (selectedImage != null) {
      FirebaseStorage _storage = FirebaseStorage.instance;
      Reference ref =
          _storage.ref().child("doctorImage").child("${DateTime.now()}.jpg");
      final UploadTask task = ref.putFile(selectedImage);
      var downloadUrl = await (await task).ref.getDownloadURL();
      print("this is the download url for doctor Image $downloadUrl");
      downloadedUrl = downloadUrl;
    }
  }
}
