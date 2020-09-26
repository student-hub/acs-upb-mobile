import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/pages/faq/service/question_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/search_bar.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:markdown/markdown.dart' as md;

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Question> questions = List<Question>();
  List<String> categories;
  String filter = '';
  bool searchClosed = true;
  List<String> activeTags = List<String>();
  Future<List<Question>> futureQuestions;

  @override
  void initState() {
    QuestionProvider questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    futureQuestions = questionProvider.fetchQuestions(context: context);
    super.initState();
  }

  Widget categoryList() => ListView(
        scrollDirection: Axis.horizontal,
        children: categories
            .map((category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Selectable(
                    label: category,
                    initiallySelected: false,
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
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).sectionFAQ,
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
      body: FutureBuilder(
          future: futureQuestions,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            questions = snapshot.data;
            categories = questions.expand((e) => e.tags).toSet().toList();
            return ListView(
              children: [
                SearchWidget(
                  title: categoryList(),
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
                QuestionsList(
                    questions: questions
                        .where((question) =>
                            filter
                                .split(' ')
                                .where((element) => element != '')
                                .fold(
                                    true,
                                    (previousValue, filter) =>
                                        previousValue &&
                                        question.question
                                            .toLowerCase()
                                            .contains(filter)) &&
                            (activeTags.isEmpty
                                ? true
                                : containsTag(activeTags, question.tags)))
                        .toList(),
                    filter: filter),
              ],
            );
          }),
    );
  }

  bool containsTag(List<String> activeTags, List<String> questionTags) {
    for (String tag in activeTags) {
      if (questionTags.contains(tag)) {
        return true;
      }
    }
    return false;
  }
}

class QuestionsList extends StatefulWidget {
  final List<Question> questions;
  final String filter;

  QuestionsList({this.questions, this.filter});

  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {
  @override
  Widget build(BuildContext context) {
    List<String> filteredWords =
        widget.filter.split(' ').where((element) => element != '').toList();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.questions.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: filteredWords.isNotEmpty
                    ? DynamicTextHighlighting(
                        text: widget.questions[index].question,
                        style: Theme.of(context).textTheme.subtitle1,
                        highlights: filteredWords,
                        color: Theme.of(context).accentColor,
                        caseSensitive: false,
                      )
                    : Text(
                        widget.questions[index].question,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                    child: MarkdownBody(
                      data: widget.questions[index].answer
                          .replaceAll('\\n', '\n'),
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
        ),
      ],
    );
  }
}
