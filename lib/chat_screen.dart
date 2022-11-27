// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String message;
  late String sender;
  TextEditingController messageController = TextEditingController();

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text(
            "SEND",
          ),
          onPressed: () {
            _firestore.collection('messages').add({
              'text': message,
              'sender': loggedInUser.email,
              'displayName': loggedInUser.displayName,
              'timestamp': DateTime.now(),
            });
            messageController.clear();
          },
        ),
        appBar: AppBar(
          title: Text("CHAT"),
          actions: [
            IconButton(
              onPressed: () async {
                _auth.signOut();
                Navigator.pop(context);
              },
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/chat.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                  final messages = snapshot.data!.docs;
                  List<ChatBubble> chatBubbles = [];
                  for (var message in messages) {
                    final messageText = message.get('text');
                    final messageSender = message.get('displayName');
                    final chatBubble = ChatBubble(messageText, messageSender,
                        messageSender == loggedInUser.displayName ? true : false);
                    chatBubbles.add(chatBubble);
                  }
                  return Expanded(
                    child: ListView(
                      children: chatBubbles,
                      padding: EdgeInsets.all(10),
                      reverse: true,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: messageController,
                  minLines: 1,
                  maxLines: null,
                  onChanged: (value) {
                    message = value;
                  },
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    hintText: "Type message",
                    focusColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  ChatBubble(this.text, this.sender, this.isMe);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              color: Colors.black38,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            decoration: BoxDecoration(
              color: isMe ? Colors.green : Colors.blue,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topRight: Radius.zero,
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.elliptical(10, 20),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.zero,
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.elliptical(10, 20),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
