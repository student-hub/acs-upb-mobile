import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';

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
  final ScrollController _scrollController = ScrollController();

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
                  .map((final category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: Theme.of(context).chipTextStyle(
                              selected: activeTags.contains(category),
                            ),
                          ),
                          selected: activeTags.contains(category),
                          onSelected: (final selection) {
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
  Widget build(final BuildContext context) {
    return AppScaffold(
      title: Text(S.current.sectionFAQ),
      actions: [
        AppScaffoldAction(
          icon: Icons.search_outlined,
          onPressed: () {
            setState(() {
              _scrollController.animateTo(0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 500));
              searchClosed = !searchClosed;
            });
          },
        )
      ],
      body: FutureBuilder(
          future: futureQuestions,
          builder: (final context, final snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            questions = snapshot.data;
            tags = questions.expand((final e) => e.tags).toSet().toList();
            return ListView(
              controller: _scrollController,
              children: [
                SearchWidget(
                  header: categoryList(),
                  onSearch: (final searchText) {
                    setState(() {
                      filter = searchText.toLowerCase();
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
      .where((final question) =>
          filter.split(' ').where((final element) => element != '').fold(
              true,
              (final previousValue, final filter) =>
                  previousValue &&
                  question.question.toLowerCase().contains(filter)) &&
          containsTag(activeTags, question.tags))
      .toList();

  bool containsTag(
      final List<String> activeTags, final List<String> questionTags) {
    if (activeTags.isEmpty) return true;
    return questionTags.any(activeTags.contains);
  }
}

class QuestionsList extends StatefulWidget {
  const QuestionsList({this.questions, this.filter});

  final List<Question> questions;
  final String filter;

  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {
  @override
  Widget build(final BuildContext context) {
    final List<String> filteredWords = widget.filter
        .split(' ')
        .where((final element) => element != '')
        .toList();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.questions.length,
        itemBuilder: (final context, final index) {
          return ExpansionTile(
            key: ValueKey(widget.questions[index].question),
            title: filteredWords.isNotEmpty
                ? Text(
                    widget.questions[index].question,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                : Text(
                    widget.questions[index].question,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: MarkdownBody(
                  fitContent: false,
                  onTapLink: (final text, final link, final title) =>
                      Utils.launchURL(link),
                  /*
                  This is a workaround because the strings in Firebase represent
                  newlines as '\n' and Firebase replaces them with '\\n'. We need
                  to replace them back for them to display properly.
                  (See GitHub issue firebase/firebase-js-sdk#2366)
                  */
                  data: widget.questions[index].answer.replaceAll('\\n', '\n'),
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
