import 'dart:convert';

import 'package:acs_upb_mobile/pages/chat/model/message_rasa.dart';
import 'package:http/http.dart' as http;

Future<MessageRasa> createMessage(
    String content, String userId, String lang) async {
  var urlPolly = 'http://35.238.148.13:5006/webhooks/rest/webhook';
  if (lang == 'ro') {
    urlPolly = 'http://35.238.148.13:5005/webhooks/rest/webhook';
  }
  final response = await http.post(
    Uri.parse(urlPolly),
    body: jsonEncode(<String, String>{'sender': userId, 'message': content}),
  );

  if (response.statusCode == 200) {
    return MessageRasa.fromJson(jsonDecode(response.body).first);
  } else {
    throw Exception('Failed to create message.');
  }
}
