import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatController {
  _ChatPageState __chatPageState;
}

class ChatPage extends StatefulWidget {
  static const routeName = '/chats';

  // final String userId;
  //
  // ChatPage(this.userId);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat support'),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Messages(),
              ),
            ],
          ),
        ));
  }
}

class Messages extends StatelessWidget {
  Future<User> getUserInformation() async {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<bool> doesUsersChatAlreadyExist(String userId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('chats')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future<void> getRightMessages(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('userId', isEqualTo: uid)
        .limit(1)
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData[0]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserInformation(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final uid = futureSnapshot.data.uid;
          return FutureBuilder(
              future: doesUsersChatAlreadyExist(uid),
              builder: (ctx, AsyncSnapshot<bool> result) {
                if (!result.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!result.data) {
                  FirebaseFirestore.instance.collection('chats').add({
                    'fullName': 'Marcel',
                    'userId': uid,
                    'imageUrl':
                        'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg'
                  });
                }
                getRightMessages(uid);
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        //Trb sa vad cum iau mesajele din colectia buna
                        .collection('/chats/ZlEI178W90aca2x9hIMZ/messages')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (ctx, chatSnapshot) {
                      if (chatSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final chatDocs = chatSnapshot.data.documents;
                      return ListView.builder(
                        reverse: true,
                        itemCount: chatDocs.length,
                        itemBuilder: (ctx, index) => MessageBubble(
                          chatDocs[index]['text'],
                          chatDocs[index]['userId'] == uid,
                          ValueKey(chatDocs[index].documentID),
                          chatDocs[index]['fullName'],
                          chatDocs[index]['imageUrl'],
                        ),
                      );
                    });
              });
        });
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String userName;
  final String userImage;

  MessageBubble(
      this.message, this.isMe, this.key, this.userName, this.userImage);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(12),
                  bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black87 : Colors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.black87 : Colors.white,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          top: 0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              userImage,
            ),
          ),
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}

class NewMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
