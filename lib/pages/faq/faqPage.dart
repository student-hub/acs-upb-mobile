import 'QuestionsList.dart';
import 'SearchWidget.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QA {
  final String question;
  final String answer;
  final String category;

  QA(this.question, this.answer, this.category);
}

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<QA> questions = List<QA>();
  List<String> categories;
  String filter = "";

  @override
  void initState() {
    questions.add(QA(
        'Cum mă conectez la eduroam?',
        'Conectarea în rețeaua eduroam se face pe baza aceluiași cont folosit și pe site-ul de cursuri. Pentru rețeaua eduroam datele de identificare vor fi de forma:',
        'General'));
    questions.add(QA(
        'Cum citesc orarul?',
        'În orar se regăsesc toate materiile care se pot face în anul respectiv. În general, acestea sunt descrise pe 4 tipuri de căsuțe...',
        'Facultate'));
    categories = questions.map((e) => e.category).toSet().toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'FAQ',
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
                filter = "";
              });
            },
          ),
          QuestionsList(
            questions: questions,
            filter: filter,
            categories: categories,
          ),
        ],
      ),
    );
  }
}
