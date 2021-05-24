import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project_doctor/constants/constants.dart';
import 'package:college_project_doctor/modal/call.dart';
import 'package:college_project_doctor/provider/userProvider.dart';
import 'package:college_project_doctor/screens/callScreen/pickUp/pickUpScreen.dart';
import 'package:college_project_doctor/services/callMethods.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickUpLayOut extends StatelessWidget {
  final Widget scaffold;
  CallMethods _callMethods = CallMethods();
  PickUpLayOut({this.scaffold});
  @override
  Widget build(BuildContext context) {
    print(Constants.uid);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return (userProvider != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: _callMethods.callStream(Constants.uid),
            builder: (context, snapshot) {
              print("trial ${Constants.uid}");
              if (snapshot.hasData && snapshot.data.data() != null) {
                Call call = Call.fromMap(snapshot.data.data());
                // ignore: missing_return
                if (!call.hasDialled) {
                  return PickUp(call: call);
                } else {
                  return scaffold;
                }
              } else {
                return scaffold;
              }
            })
        : Container(child: Center(child: CircularProgressIndicator()));
  }
}
