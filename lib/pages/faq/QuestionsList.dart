import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

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
    widget.filter.split(" ").where((element) => element != "").toList();

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
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
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