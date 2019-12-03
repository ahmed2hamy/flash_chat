import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String sender;
  final String time;
  final bool isMe;

  ChatBubble({this.text, this.sender, this.time, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              sender,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
            Material(
              elevation: 6,
              color: isMe ? Colors.white : Colors.lightBlueAccent,
              borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(0) : Radius.circular(20),
                topRight: isMe ? Radius.circular(20) : Radius.circular(0),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isMe ? Colors.black54 : Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
