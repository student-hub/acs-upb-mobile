import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsListPage extends StatelessWidget {
  static const routeName = '/chat_support';

  Future<User> getUserInformation() async {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Support'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getUserInformation(),
                builder: (_, futureSnapshot) {
                  if (futureSnapshot.connectionState ==
                      ConnectionState.done) {
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .snapshots(),
                      builder: (__, chatSnapshot) {
                        if (futureSnapshot.connectionState ==
                            ConnectionState.done) {
                          final chatsList = chatSnapshot.data.documents;
                          return ListView.builder(
                            itemCount: chatsList.length,//chatsList.length,
                            itemBuilder: (_, index) => Column(
                              children: [
                                ChatsListItem(
                                  userId: chatsList[index]['userId'],
                                  fullName: chatsList[index]['fullName'],
                                  imageUrl: chatsList[index]['imageUrl'],
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatsListItem extends StatelessWidget {
  final String userId;
  final String fullName;
  final String imageUrl;

  ChatsListItem(
      {@required this.userId,
      @required this.fullName,
      @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fullName),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: const Icon(Icons.delete),
      ),
    );
  }
}
