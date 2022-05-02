import 'package:acs_upb_mobile/pages/chat/model/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension DatabaseConversation on Conversation {
  static Conversation fromSnap(DocumentSnapshot snap) {
    final data = snap.data();
    return Conversation(
        uid: snap.id,
        messages: List.from(data['messages'] ?? []));
  }

  Map<String, dynamic> toData() {
    return {
      'messages': messages
    };
  }
}

Future<Conversation> addConversation() async {
  final fireStoreConversationRef =
      FirebaseFirestore.instance.collection('conversations').doc();
  print(fireStoreConversationRef.id);
  final Conversation conversation =
      Conversation(uid: fireStoreConversationRef.id);
  await fireStoreConversationRef.set(conversation.toData());
  return conversation;
}
