import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'faqPage.dart';

class QuestionsList extends StatefulWidget {
  final List<QA> questions;
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

    List<QA> filteredList = widget.questions
        .where((element) =>
            element.question
                .toLowerCase()
                .contains(widget.filter.toLowerCase()) &&
            (activeCategory == "" ? true : element.category == activeCategory))
        .toList();

    List categoryList = widget.categories
        .map((category) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
        ))
        .toList();

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
                title: SubstringHighlight(
                  text: filteredList[index].question,
                  textStyle: Theme.of(context).textTheme.subtitle1,
                  term: widget.filter,
                  textStyleHighlight: TextStyle(
                    fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                    fontWeight:
                        Theme.of(context).textTheme.subtitle1.fontWeight,
                    fontStyle: Theme.of(context).textTheme.subtitle1.fontStyle,
                    color: Colors.blue,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      filteredList[index].answer,
                      style: Theme.of(context).textTheme.bodyText2,
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
