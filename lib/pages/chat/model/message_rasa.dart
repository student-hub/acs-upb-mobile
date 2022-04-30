import 'package:flutter/material.dart';

class MessageRasa {
  const MessageRasa({@required this.id, @required this.messageText});

  final String id;
  final String messageText;

  factory MessageRasa.fromJson(Map<String, dynamic> json) {
    return MessageRasa(
      id: json['recipient_id'],
      messageText: json['text'],
    );
  }
}