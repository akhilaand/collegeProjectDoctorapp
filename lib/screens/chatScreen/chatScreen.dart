import 'package:college_project_doctor/constants/colors.dart';
import 'package:college_project_doctor/constants/constants.dart';
import 'package:college_project_doctor/constants/styles.dart';
import 'package:college_project_doctor/services/database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatScreen extends StatefulWidget {
  String doctorName;
  String chatRoomid;

  ChatScreen({
    this.doctorName,
    this.chatRoomid,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream messageStream;
  DataBaseMethods _databaseServices = DataBaseMethods();
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _databaseServices.getMessage(widget.chatRoomid).catchError((onError) {
      print("print $onError");
    }).then((value) {
      if (value != null) {
        setState(() {
          messageStream = value;
        });
      } else {
        print("value is null from initstate on chatscreen");
      }
    });
    super.initState();
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    isSendByMe: snapshot.data.docs[index].get("send-by") ==
                        Constants.myName,
                    message: snapshot.data.docs[index].get("message"),
                    time: snapshot.data.docs[index].get("time"),
                  );
                });
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // CircleAvatar(
            //   radius: 20,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(40),
            //     child: Image.network(
            //       widget.doctorPic,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            SizedBox(
              width: 10,
            ),
            Text(widget.doctorName),
          ],
        ),
        actions: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: green),
            child: Icon(Icons.call),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: green),
            child: Icon(Icons.video_call_rounded),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: chatMessageList()),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 8, right: 8),
            child: Container(
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: boxDecorationStyle,
                height: 60.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: TextField(
                    controller: messageController,
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            sendMessage();
                            createChatRoom(
                                widget.chatRoomid, widget.doctorName);
                          }),
                      // Icon(Icons.send),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14.0),
                      hintText: "Enter your message",
                      hintStyle: hintStyle,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  createChatRoom(String chatRoomId, String doctorName) {
    if (doctorName != Constants.myName) {
      List<String> users = [doctorName, Constants.myName];
      Map<String, dynamic> chatRoomMAP = {
        "users": users,
        "chatRoomId": chatRoomId,
        "time": DateTime.now().microsecondsSinceEpoch,
        // "doctorImage": widget.doctorPic
      };
      _databaseServices.createChatRoom(chatRoomId, chatRoomMAP);
      messageController.text = "";
    }
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "send-by": Constants.myName,
        "time": "${DateTime.now().hour}:${DateTime.now().minute}",
        "sortingTime": DateTime.now().microsecondsSinceEpoch
      };
      _databaseServices.sendMessage(widget.chatRoomid, messageMap);
    }
  }
}

class MessageTile extends StatelessWidget {
  final bool isSendByMe;
  final String message;
  var time;
  MessageTile({this.message, this.isSendByMe, this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isSendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: isSendByMe ? Colors.grey.shade500 : Colors.blue,
              borderRadius: isSendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    time.toString(),
                    style: TextStyle(
                        color: isSendByMe
                            ? Colors.grey.shade500
                            : Colors.grey.shade300),
                    textAlign: TextAlign.end,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
