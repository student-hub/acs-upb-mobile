import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    return Column(
      children: [
        Container(
          height: 40,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (activeCategory == widget.categories[index]) {
                          activeCategory = "";
                        } else {
                          activeCategory = widget.categories[index];
                        }
                      });
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          color: widget.categories[index] == activeCategory
                              ? Theme.of(context).accentColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border:
                          Border.all(color: Theme.of(context).accentColor)),
                      child: Center(
                        child: Text(
                          widget.categories[index],
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    filteredList[index].question,
                    style: Theme.of(context).textTheme.subtitle1,
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
              }),
        ),
      ],
    );
  }
}
