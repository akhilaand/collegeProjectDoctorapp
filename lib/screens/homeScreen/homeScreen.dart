import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project_doctor/constants/constants.dart';
import 'package:college_project_doctor/screens/Login/welcomeScreen.dart';
import 'package:college_project_doctor/helper/helperFunction.dart';
import 'package:college_project_doctor/screens/callScreen/pickUp/pickUpLayout.dart';
import 'package:college_project_doctor/services/auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthMethods _authMethods = AuthMethods();
  @override
  void initState() {
    callFunctions();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(HelperFunctions.getUserNameSharedPreference().toString());

    return MaterialApp(
      home: PickUpLayOut(
        scaffold: Scaffold(
          appBar: AppBar(
            title: Text("Hii, ${Constants.myName}"),
            actions: [
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    _authMethods.signOut();
                    HelperFunctions.saveUserLoggedInSharedPreference(false);
                    HelperFunctions.remove();

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  })
            ],
          ),
          body: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Column(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Appointments")
                            .snapshots(),
                        builder: (context, snapshot) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              !snapshot.hasData
                                  ? CircularProgressIndicator()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Upcoming Appointments",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade500),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 450,
                                          child: ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              itemBuilder: (context, index) {
                                                String userName = snapshot
                                                    .data.docs[index]["name"];
                                                return Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Card(
                                                        child: ListTile(
                                                          leading: CircleAvatar(
                                                            child: Text(userName
                                                                .substring(0, 1)
                                                                .toUpperCase()),
                                                            radius: 30,
                                                          ),
                                                          title: Text(
                                                              "Name : ${snapshot.data.docs[index]["name"]}"),
                                                          isThreeLine: true,
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Age : ${snapshot.data.docs[index]["age"]}"),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                  "Gender : ${snapshot.data.docs[index]["gender"]}")
                                                            ],
                                                          ),
                                                          trailing: Text("Date : ${snapshot.data.docs[index]["date"]}"),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                            ],
                          );
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void callFunctions() async {
    await getUserInfo();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.uid = await HelperFunctions.getUserUIDSharedPreference();
  }
}
