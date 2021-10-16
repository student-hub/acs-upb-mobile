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
    final result = await FirebaseFirestore.instance
        .collection('chats').doc(userId);
    print(result.id);
  }

  Future<void> getRightMessages(String uid) async {
    final DocumentReference ref = FirebaseFirestore.instance
        .collection('chats')
        .doc(uid);
    final QuerySnapshot querySnapshot = await ref.collection('messages').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
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
                //TODO: Trebuie sa vad cum verific daca exista sau nu chat-ul si daca nu sa il creeze
                final chatsDb = FirebaseFirestore.instance.collection('chats');
                if (!result.hasData) {
                   chatsDb.doc(uid).set({
                    'fullName': 'Marcel',
                    'imageUrl':
                    'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg'
                  });
                  // return const Center(
                  //   child: CircularProgressIndicator(),
                  // );
                }
                if(!result.data) {
                  chatsDb.doc(uid).collection('messages').add({
                    'date' : Timestamp.now(),
                    'text' : 'Salut! Cu ce te putem ajuta?',
                    'imageUrl' : 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
                    'userId' : 'ACS',
                    'fullName' : 'ACS UPB MOBILE',
                  });
                }
                getRightMessages(uid);
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('/chats/$uid/messages')
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
                      print(uid);
                      print(chatDocs[0]['userId']);
                      print(chatDocs[1]['userId']);
                      return ListView.builder(
                        reverse: true,
                        itemCount: chatDocs.length,
                        itemBuilder: (ctx, index) => MessageBubble(
                          message: chatDocs[index]['text'],
                          isMe: chatDocs[index]['userId'] == uid,
                          key: ValueKey(chatDocs[index].documentID),
                          userName: chatDocs[index]['fullName'],
                          userImage: chatDocs[index]['imageUrl'],
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
  {@required this.message,@required this.isMe,@required this.key,@required this.userName,@required this.userImage});

  @override
  Widget build(BuildContext context) {
    print(isMe);
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
