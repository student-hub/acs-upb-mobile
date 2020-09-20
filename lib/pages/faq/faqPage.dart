import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/pages/faq/service/question_service.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'QuestionsList.dart';
import 'SearchWidget.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Question> questions = List<Question>();
  List<String> categories;
  String filter = "";
  bool searchClosed = true;
  String activeCategory = "";
  var controllers = Map<String, SelectableController>();

  Widget categoryList() => ListView(
        scrollDirection: Axis.horizontal,
        children: categories
            .map((category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Selectable(
                    controller: controllers[category],
                    label: category,
                    initiallySelected: false,
                    onSelected: (selection) {
                      setState(() {
                        activeCategory = "";
                        if (selection) {
                          controllers.values.forEach((element) {
                            element.deselect();
                          });
                          controllers[category].select();
                          activeCategory = category;
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
      body: FutureBuilder(
          future: QuestionsService().getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            questions = QuestionsService().getQuestions(snapshot.data);
            categories = questions.map((e) => e.category).toSet().toList();
            categories.forEach((element) {
              controllers.putIfAbsent(element, () => SelectableController());
            });
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
                      filter = "";
                    });
                  },
                  searchClosed: searchClosed,
                ),
                QuestionsList(
                    questions: questions
                        .where((question) =>
                            filter
                                .split(" ")
                                .where((element) => element != "")
                                .fold(
                                    true,
                                    (previousValue, filter) =>
                                        previousValue &&
                                        question.question
                                            .toLowerCase()
                                            .contains(filter)) &&
                            (activeCategory == ""
                                ? true
                                : question.category == activeCategory))
                        .toList(),
                    filter: filter),
              ],
            );
          }),
    );
  }
}
