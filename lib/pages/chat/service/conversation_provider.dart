import 'package:acs_upb_mobile/pages/chat/model/conversation.dart';
import 'package:acs_upb_mobile/pages/chat/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension DatabaseConversation on Conversation {
  static Conversation fromSnap(DocumentSnapshot snap) {
    final data = snap.data();
    return Conversation(
        uid: snap.id, messages: List.from(data['messages'] ?? []));
  }

  Map<String, dynamic> toData() {
    return {
      'messages': List<dynamic>.from(messages.map((x) => x.toJson())),
    };
  }
}

Future<Conversation> addConversation(List<Message> messages) async {
  final fireStoreConversationRef =
      FirebaseFirestore.instance.collection('conversations').doc();
  final Conversation conversation =
      Conversation(uid: fireStoreConversationRef.id, messages: messages);

  await fireStoreConversationRef.set(conversation.toData());
  return conversation;
}

Future<void> updateConversation(
    String uid, List<Message> messages) async {
  final fireStoreConversationRef =
      FirebaseFirestore.instance.collection('conversations').doc(uid);
  final Conversation conversation =
      Conversation(uid: fireStoreConversationRef.id, messages: messages);

  await fireStoreConversationRef.update(conversation.toData());
}
