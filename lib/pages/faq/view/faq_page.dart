import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../generated/l10n.dart';
import '../../../resources/theme.dart';
import '../../../resources/utils.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/search_bar.dart';
import '../model/question.dart';
import '../service/question_provider.dart';

class FaqPage extends StatefulWidget {
  static const String routeName = '/faq';

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Question> questions = <Question>[];
  List<String> tags;
  String filter = '';
  bool searchClosed = true;
  List<String> activeTags = <String>[];
  Future<List<Question>> futureQuestions;

  @override
  void initState() {
    final QuestionProvider questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    futureQuestions = questionProvider.fetchQuestions();
    super.initState();
  }

  Widget categoryList() => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[const SizedBox(width: 10)] +
              tags
                  .map((category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: Theme.of(context).chipTextStyle(
                              selected: activeTags.contains(category),
                            ),
                          ),
                          selected: activeTags.contains(category),
                          onSelected: (selection) {
                            setState(() {
                              if (selection) {
                                activeTags.add(category);
                              } else {
                                activeTags.remove(category);
                              }
                            });
                          },
                        ),
                      ))
                  .toList() +
              <Widget>[const SizedBox(width: 10)],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.sectionFAQ),
      actions: [
        AppScaffoldAction(
          icon: Icons.search_outlined,
          onPressed: () {
            setState(() {
              searchClosed = !searchClosed;
            });
          },
        )
      ],
      body: FutureBuilder(
          future: futureQuestions,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            questions = snapshot.data;
            tags = questions.expand((e) => e.tags).toSet().toList();
            return ListView(
              children: [
                SearchWidget(
                  header: categoryList(),
                  onSearch: (searchText) {
                    setState(() {
                      filter = searchText;
                    });
                  },
                  cancelCallback: () {
                    setState(() {
                      searchClosed = true;
                      filter = '';
                    });
                  },
                  searchClosed: searchClosed,
                ),
                QuestionsList(questions: filteredQuestions, filter: filter),
              ],
            );
          }),
    );
  }

  List<Question> get filteredQuestions => questions
      .where((question) =>
          filter.split(' ').where((element) => element != '').fold(
              true,
              (previousValue, filter) =>
                  previousValue &&
                  question.question.toLowerCase().contains(filter)) &&
          containsTag(activeTags, question.tags))
      .toList();

  bool containsTag(List<String> activeTags, List<String> questionTags) {
    if (activeTags.isEmpty) return true;
    return questionTags.any(activeTags.contains);
  }
}

class QuestionsList extends StatelessWidget {
  const QuestionsList({this.questions, this.filter});

  final List<Question> questions;
  final String filter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            key: ValueKey(questions[index].question),
            // NOTE: This package only highlights the exact search term, so some
            // questions may be matched without displaying any highlight.
            //
            // https://github.com/remoteportal/substring_highlight/issues/17
            title: SubstringHighlight(
              text: questions[index].question,
              term: filter,
              textStyle: Theme.of(context).textTheme.subtitle1,
              textStyleHighlight:
                  Theme.of(context).textTheme.subtitle1.copyWith(
                        backgroundColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                      ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: MarkdownBody(
                  fitContent: false,
                  onTapLink: (text, link, title) => Utils.launchURL(link),
                  // This is a workaround because the strings in Firebase represent
                  // newlines as '\n' and Firebase replaces them with '\\n'. We need
                  // to replace them back for them to display properly.
                  // (See GitHub issue firebase/firebase-js-sdk#2366)
                  data: questions[index].answer.replaceAll('\\n', '\n'),
                  extensionSet: md.ExtensionSet(
                      md.ExtensionSet.gitHubFlavored.blockSyntaxes, [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
