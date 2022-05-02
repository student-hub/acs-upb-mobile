import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/chat/model/conversation.dart';
import 'package:acs_upb_mobile/pages/chat/model/message_rasa.dart';
import 'package:acs_upb_mobile/pages/chat/service/conversation_provider.dart';
import 'package:acs_upb_mobile/pages/chat/service/message_rasa_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final languagePref = PrefService.get('language');
  List<ChatMessage> _messages;
  // = [
  //   const ChatMessage(content: 'How can I help you?', type: 'receiver'),
  //   const ChatMessage(content: 'Hello!', type: 'receiver'),
  // ];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  MessageRasa _futureMessage;
  Conversation conversation;
  User user;

  Future<void> _fetchUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = await authProvider.currentUser;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchConversation() async {
    final conv = await addConversation();
    setState(() {
      conversation = conv;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchConversation();

    if (languagePref == 'ro') {
      _messages = [
        const ChatMessage(content: 'Cu ce te pot ajuta?', type: 'receiver'),
        const ChatMessage(content: 'Salut!', type: 'receiver'),
      ];
    } else {
      _messages = [
        const ChatMessage(content: 'How can I help you?', type: 'receiver'),
        const ChatMessage(content: 'Hello!', type: 'receiver'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {

    return AppScaffold(
      title: const Text('Polly'),
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
              onPressed: () async {
                var auxMessage = await createMessage(_textController.text,
                    user.uid, languagePref);
                _handleSubmitted(_textController.text);
                setState(() {
                  _futureMessage = auxMessage;
                  final ChatMessage message = ChatMessage(
                    content: _futureMessage.messageText,
                    type: 'receiver',
                  );
                  _messages.insert(0, message);
                });
                // _handleReceived(),
              },
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
      content: messageContent,
      type: 'sender',
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
  }

}

class ChatMessage extends StatefulWidget {
  const ChatMessage({Key key, this.content, this.type}) : super(key: key);

  final String content;
  final String type;

  @override
  _ChatMessage createState() => _ChatMessage();
}

class _ChatMessage extends State<ChatMessage> {
  bool _isFlagged = false;
  Color _flagColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.type == 'receiver' ? Alignment.topLeft : Alignment.topRight,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.type == 'receiver'
                ? Theme.of(context).cardColor
                : Theme.of(context).primaryColor,
          ),
          padding: const EdgeInsets.all(16),
          child: widget.type == 'sender'
              ? Text(
                  widget.content,
                  style: const TextStyle(fontSize: 15),
                )
              : Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                     child: GestureDetector(
                    child: Text(
                      widget.content,
                      style: const TextStyle(fontSize: 15),
                    ),
                    onTap: _flagMessage
                  )),
                 Icon(Icons.flag, color: _flagColor)
                ])),
    );
  }

  void _flagMessage() {
    setState(() {
      if (_isFlagged) {
        _isFlagged = false;
        _flagColor = Colors.black;
      } else {
        _isFlagged = true;
        _flagColor = Colors.red;
      }
    });
  }
}
