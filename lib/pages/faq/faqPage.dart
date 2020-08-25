import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/pages/faq/service/question_service.dart';
import 'QuestionsList.dart';
import 'SearchWidget.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Question> questions = List<Question>();
  List<String> categories;
  String filter = "";
  bool searchClosed = true;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'FAQ',
      actions: [
        AppScaffoldAction(
          icon: Icons.search,
          onPressed: () {
            setState(() {
              searchClosed = !searchClosed;
            });
          },
        )
      ],
      body: ListView(
        children: [
          SearchWidget(
            title: Text(
              'Top Questions',
              style: Theme.of(context).textTheme.headline5,
            ),
            onSearch: (searchText) {
              setState(() {
                filter = searchText;
              });
            },
            cancelCallback: () {
              setState(() {
                searchClosed = true;
                filter = "";
              });
            },
            searchClosed: searchClosed,
          ),
          FutureBuilder(
            future: QuestionsService().getDocuments(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              questions = QuestionsService().getQuestions(snapshot.data);
              categories = questions.map((e) => e.category).toSet().toList();
              return QuestionsList(
                  questions: questions, categories: categories, filter: filter);
            },
          ),
        ],
      ),
    );
  }
}
