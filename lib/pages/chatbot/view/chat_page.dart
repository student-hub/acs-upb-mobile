import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> _messages = [
    ChatMessage(messageContent: "What are you doing?", messageType: "receiver"),
    ChatMessage(messageContent: "Hello, Will!", messageType: "receiver"),
  ]; //for testing
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: const Text('Chatbot'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(4),
              reverse: true,
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => Container(
                  padding: const EdgeInsets.all(10), child: _messages[index]),
            ),
          ),
          const Divider(height: 1),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Send a message'),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }

  void _handleSubmitted(String messageContent) {
    _textController.clear();
    final ChatMessage message = ChatMessage(
      messageContent: messageContent,
      messageType: 'sender',
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({this.messageContent, this.messageType});

  final String messageContent;
  final String messageType;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          messageType == 'receiver' ? Alignment.topLeft : Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: messageType == 'receiver'
              ? Theme.of(context).cardColor
              : Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.all(16),
        child: Text(
          messageContent,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
