import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/chat/model/conversation.dart';
import 'package:acs_upb_mobile/pages/chat/model/message.dart';
import 'package:acs_upb_mobile/pages/chat/model/message_rasa.dart';
import 'package:acs_upb_mobile/pages/chat/service/conversation_provider.dart';
import 'package:acs_upb_mobile/pages/chat/service/message_rasa_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:preferences/preference_service.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final languagePref = PrefService.get('language');
  List<ChatMessage> _messages;
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _idxMess = 2;
  MessageRasa _futureMessage;
  Conversation conversation;
  User user;
  Color _sendButtonColor;

  Future<void> _fetchUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = await authProvider.currentUser;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchConversation() async {
    final ConversationProvider conProvider =
        Provider.of<ConversationProvider>(context, listen: false);
    conversation = await conProvider.addConversation(languagePref);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ConversationProvider>(context, listen: false)
        .initListOfMessages();
    _fetchConversation();
    _fetchUser();
    _messages = [
      ChatMessage(content: S.current.messageContent, type: 'receiver', idx: 0),
      ChatMessage(content: S.current.messageGreeting, type: 'receiver', idx: 1),
      ChatMessage(content: S.current.messageConsent, type: 'receiver', idx: 2),
      ChatMessage(
          content:
              'Id: ${Provider.of<ConversationProvider>(context, listen: false).getConversationUid()}',
          type: 'receiver',
          idx: 3)
    ];
    Future.delayed(Duration.zero,
        () => {_sendButtonColor = Theme.of(context).disabledColor});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
      title: const Text('Polly'),
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
              onSubmitted: (value) async {
                if (_textController.text.isNotEmpty) {
                  await _handleMessages();
                }
              },
              onChanged: (text) {
                if (text.isNotEmpty) {
                  setState(() {
                    _sendButtonColor = Theme.of(context).primaryColor;
                  });
                } else {
                  setState(() {
                    _sendButtonColor = Theme.of(context).disabledColor;
                  });
                }
              },
              decoration: InputDecoration.collapsed(
                  hintText: S.current.hintMessageChatbot),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: _sendButtonColor,
              onPressed: () async {
                if (_textController.text.isNotEmpty) {
                  await _handleMessages();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleMessages() async {
    final auxMessage =
        await createMessage(_textController.text, user.uid, languagePref);
    _handleSubmitted(_textController.text);
    setState(() {
      _futureMessage = auxMessage;
      final ChatMessage message = ChatMessage(
        content: _futureMessage.messageText,
        type: 'receiver',
        idx: _idxMess,
      );
      final Message messageConv = Message(
          index: _idxMess,
          content: _futureMessage.messageText,
          entity: 'Polly',
          isFlagged: false);
      _idxMess = _idxMess + 1;
      Provider.of<ConversationProvider>(context, listen: false)
          .updateConversation(conversation.uid, messageConv, languagePref);
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String messageContent) {
    _textController.clear();
    final ChatMessage message = ChatMessage(
      content: messageContent,
      type: 'sender',
      idx: _idxMess,
    );
    final Message messageConv = Message(
        index: _idxMess,
        content: messageContent,
        entity: 'Human',
        isFlagged: false);
    Provider.of<ConversationProvider>(context, listen: false)
        .updateListOfMessages(messageConv);
    _idxMess = _idxMess + 1;
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
  }
}

class ChatMessage extends StatefulWidget {
  const ChatMessage({Key key, this.content, this.type, this.idx})
      : super(key: key);

  final String content;
  final String type;
  final int idx;

  @override
  _ChatMessage createState() => _ChatMessage();
}

class _ChatMessage extends State<ChatMessage> {
  bool _isFlagged = false;
  Color _flagColor;

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
              ? SelectableText(
                  widget.content,
                  style: const TextStyle(fontSize: 15),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                      Flexible(
                        child: SelectableText(
                          widget.content,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      GestureDetector(
                        child: Icon(Icons.flag,
                            color:
                                _flagColor ?? Theme.of(context).primaryColor),
                        onTap: () {
                          _flagMessage();
                        },
                      )
                    ])),
    );
  }

  void _flagMessage() {
    setState(() {
      if (_isFlagged) {
        _isFlagged = false;
        _flagColor = Theme.of(context).primaryColor;
      } else {
        _isFlagged = true;
        _flagColor = Theme.of(context).errorColor;
      }
    });
    Provider.of<ConversationProvider>(context, listen: false)
        .flagMessage(widget.idx, _isFlagged);
  }
}
