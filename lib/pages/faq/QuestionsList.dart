import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class QuestionsList extends StatefulWidget {
  final List<Question> questions;
  final String filter;
  final List<String> categories;

  QuestionsList({this.questions, this.filter, this.categories});

  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {
  String activeCategory = "";

  @override
  Widget build(BuildContext context) {
    List<Question> filteredList = widget.questions
        .where((question) =>
            widget.filter.split(" ").where((element) => element != "").fold(
                true,
                (previousValue, filter) =>
                    previousValue &&
                    question.question.toLowerCase().contains(filter)) &&
            (activeCategory == "" ? true : question.category == activeCategory))
        .toList();

    List categoryList = widget.categories
        .map((category) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: 100,
                child: Selectable(
                  label: category,
                  initiallySelected: false,
                  onSelected: (selection) {
                    setState(() {
                      activeCategory = "";
                      if (selection) {
                        activeCategory = category;
                      }
                    });
                  },
                ),
              ),
            ))
        .toList();

    List<String> filteredWords =
        widget.filter.split(" ").where((element) => element != "").toList();

    return Column(
      children: [
        Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: categoryList,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: filteredWords.isNotEmpty
                    ? DynamicTextHighlighting(
                        text: filteredList[index].question,
                        style: Theme.of(context).textTheme.subtitle1,
                        highlights: filteredWords,
                        color: Colors.blue,
                        caseSensitive: false,
                      )
                    : Text(
                        filteredList[index].question,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MarkdownBody(
                      data: filteredList[index].answer,
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
