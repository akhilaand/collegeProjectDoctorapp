import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project_doctor/constants/constants.dart';
import 'package:college_project_doctor/modal/user.dart';

class DataBaseMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  uploadDoctorDetail(doctorDetailMap, loggedInUserId) async {
    print("user id is $loggedInUserId");
    return await _firestore.collection("doctors").doc(loggedInUserId).set(
        doctorDetailMap); //for adding doctor details to firestore on registration time
  }
  Future<User1> getUserDetails() async {
    DocumentSnapshot documentSnapshot =
    await _firestore.collection("user").doc(Constants.uid).get();
    return User1.fromMap(documentSnapshot.data());
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
