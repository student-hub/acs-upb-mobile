import 'package:acs_upb_mobile/pages/chat/model/message.dart';
import 'package:meta/meta.dart';

class Conversation {
  Conversation(
      {@required this.uid,
        this.language,
        this.messages});

  final String uid;
  String language;

  List<Message> messages;

}
