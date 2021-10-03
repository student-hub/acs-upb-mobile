import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../../../generated/l10n.dart';
import '../../../resources/remote_config.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/search_bar.dart';
import 'classes_search_results.dart';
import 'people_search_results.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  bool searchClosed = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.navigationSearch),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SearchWidget(
            onSearch: (searchText) => {setState(() => query = searchText)},
            cancelCallback: () => {setState(() => query = '')},
            searchClosed: false,
          ),
          PeopleSearchResults(query: query),
          ClassesSearchResults(query: query),
          if (RemoteConfigService.chatEnabled && query.isNotEmpty)
            ChatbotIntro()
        ],
      ),
    );
  }
}

class ChatbotIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        const Image(
          image: AssetImage('assets/illustrations/undraw_chat_image.png'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(S.current.messageAnotherQuestion)),
              Text(
                S.current.messageTalkToChatbot,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              )
            ],
          ),
        )
      ],
    ));
  }
}
