import 'package:acs_upb_mobile/pages/chat/model/message.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:meta/meta.dart';

class Conversation {
  Conversation(
      {@required this.uid,
        this.messages});

  final String uid;

  List<Message> messages;

}
