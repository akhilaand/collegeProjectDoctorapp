import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project_doctor/constants/constants.dart';

class DataBaseMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  uploadDoctorDetail(doctorDetailMap, loggedInUserId) async {
    print("user id is $loggedInUserId");
    return await _firestore.collection("doctors").doc(loggedInUserId).set(
        doctorDetailMap); //for adding doctor details to firestore on registration time
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    _firestore
        .collection("doctor-patient chats")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((onError) {
      print("error on creating chatRoom ${onError.toString()}");
    });
  }

  sendMessage(String chatRoomID, messageMap) {
    _firestore
        .collection("doctor-patient chats")
        .doc(chatRoomID)
        .collection("chats")
        .add(messageMap);
  }

  Future getMessage(String chatRoomID) async {
    return await _firestore
        .collection("doctor-patient chats")
        .doc(chatRoomID)
        .collection("chats")
        .orderBy("sortingTime", descending: true)
        .snapshots();
  }

  Future getChatTile() async {
    return await _firestore
        .collection("doctor-patient chats")
        .orderBy("time", descending: true)
        .where("users", arrayContains: Constants.myName)
        .snapshots();
  }
}
