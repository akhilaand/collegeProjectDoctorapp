import 'package:college_project_doctor/constants/constants.dart';
import 'package:college_project_doctor/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chatScreen.dart';

class ChatMainScreen extends StatefulWidget {
  @override
  _ChatMainScreenState createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  Stream chatRoomStream;
  DataBaseMethods _databaseServices = DataBaseMethods();
  @override
  void initState() {
    // TODO: implement initState
    callFunctions();
    print(Constants.myName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
      ),
      body: Column(
        children: [chatRoomLIST()],
      ),
    );
  }

  callFunctions() async {
    await getMessageStream();
  }

  getMessageStream() async {
    await _databaseServices.getChatTile().then((value) {
      setState(() {
        print("get");
        chatRoomStream = value;
      });
    });
  }

  Widget chatRoomLIST() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("passed");
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  print("this ${Constants.myName}");
                  return ChatRoomListTile(
                    chatRoom: snapshot.data.docs[index].get("chatRoomId"),
                    patientUid: snapshot.data.docs[index].get("userUid"),
                    patientName: snapshot.data.docs[index].get("userName"),
                    username: snapshot.data.docs[index]
                        .get("chatRoomId")
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                  );
                });
          } else {
            print("no data");
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Currently you doesn't have ant chats with doctors")
              ],
            );
            print("no data");
          }
        });
  }
}

class ChatRoomListTile extends StatelessWidget {
  final String username;
  final String chatRoom;
  final String patientUid;
  final String patientName;
  ChatRoomListTile(
      {this.username, this.chatRoom, this.patientUid, this.patientName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            print(chatRoom);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        chatRoomid: chatRoom,
                        doctorName: username,
                        patientName: patientName,
                        patientUid: patientUid)));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 60,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
backgroundImage: AssetImage(
  "assets/images/avatar.jpg"
),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    username.toString(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
