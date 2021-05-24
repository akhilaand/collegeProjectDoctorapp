import 'dart:math';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:college_project_doctor/modal/call.dart';
import 'package:college_project_doctor/screens/callScreen/callingScreen/callScreen.dart';
import 'package:college_project_doctor/services/callMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  static dial(Call from, Call to, context) async {
    Call call = Call(
        callerId: from.callerId,
        callerName: from.callerName,
        // callerPic: from.callerPic,
        recieverId: to.recieverId,
        recieverName: to.recieverName,
        // recieverPic: to.recieverPic,
        channelId: "122");
    bool callMade = await callMethods.makeCall(call);
    call.hasDialled = true;
    if (callMade) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                    call: call,
                    role: ClientRole.Broadcaster,
                  )));
    }
  }
}
