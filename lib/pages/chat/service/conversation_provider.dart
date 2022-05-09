import 'package:acs_upb_mobile/pages/chat/model/conversation.dart';
import 'package:acs_upb_mobile/pages/chat/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

extension DatabaseConversation on Conversation {
  static Conversation fromSnap(DocumentSnapshot snap) {
    final data = snap.data();
    return Conversation(
        uid: snap.id,
        language: data['language'],
        messages: List.from(data['messages'] ?? []));
  }

  Map<String, dynamic> toData() {
    return {
      'language': language,
      'messages': List<dynamic>.from(messages.map((x) => x.toJson())),
    };
  }
}

class ConversationProvider with ChangeNotifier {
  ConversationProvider() {
    _savedMessages = [
      Message(
          index: 0,
          content: S.current.messageGreeting,
          entity: 'Polly',
          isFlagged: false),
      Message(
          index: 1,
          content: S.current.messageContent,
          entity: 'Polly',
          isFlagged: false),
    ];
  }

  List<Message> _savedMessages;

  void updateListOfMessages(Message messageConv) {
    _savedMessages.insert(0, messageConv);
  }

  Future<Conversation> addConversation(String language) async {
    final fireStoreConversationRef =
    FirebaseFirestore.instance.collection('conversations').doc();
    final Conversation conversation = Conversation(
        uid: fireStoreConversationRef.id,
        language: language,
        messages: _savedMessages);

    await fireStoreConversationRef.set(conversation.toData());
    return conversation;
  }

  Future<void> updateConversation(String uid, Message messageConv,
      String language) async {
    _savedMessages.insert(0, messageConv);
    final fireStoreConversationRef =
    FirebaseFirestore.instance.collection('conversations').doc(uid);
    final Conversation conversation = Conversation(
        uid: fireStoreConversationRef.id,
        language: language,
        messages: _savedMessages);

    await fireStoreConversationRef.update(conversation.toData());
  }
}
