import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:college_project_doctor/constants/colors.dart';
import 'package:college_project_doctor/modal/call.dart';
import 'package:college_project_doctor/screens/callScreen/callingScreen/callScreen.dart';

import 'package:college_project_doctor/services/callMethods.dart';
import "package:flutter/material.dart";

class PickUp extends StatelessWidget {
  CallMethods _callMethods = CallMethods();
  final Call call;
  PickUp({Key key, this.call}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Incoming",
              style: TextStyle(fontSize: 30),
            ),
            // Image.network(
            //   call.callerPic,
            //   width: 150,
            //   height: 150,
            // ),
            Text(
              call.callerName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.call_end,
                      color: red,
                    ),
                    onPressed: () async {
                      await _callMethods.endCall(call);
                    }),
                IconButton(
                    icon: Icon(
                      Icons.call,
                      color: green,
                    ),
                    onPressed: () async {
                      print("this is the data printed${call.channelId}");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CallScreen(
                                    call: call,
                                    role: ClientRole.Audience,
                                  )));
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
