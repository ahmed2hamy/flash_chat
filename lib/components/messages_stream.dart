import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MessagesStream extends StatefulWidget {
  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  void _getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').orderBy('timeStamp').snapshots(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          final messages = snapshot.data.documents.reversed;
          List<ChatBubble> chatBubbles = [];

          for (var message in messages) {
            final msgText = message.data['text'];
            final msgSender = message.data['sender'];
            final messageTime = message.data['timeStamp'];
            final currentUser = loggedInUser.email;
            DateTime date = DateTime.fromMillisecondsSinceEpoch(messageTime);
            final format = DateFormat('HH:mm');
            final mTime = format.format(date);
            final chatBubble = ChatBubble(
              text: msgText,
              sender: msgSender,
              time: mTime,
              isMe: currentUser == msgSender,
            );
            if (msgText != null) {
              chatBubbles.add(chatBubble);
            }
          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              children: chatBubbles,
            ),
          );
        }
      },
    );
  }
}
