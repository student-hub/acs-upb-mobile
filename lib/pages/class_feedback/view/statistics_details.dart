import 'dart:math';

import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';

class FeedbackStatisticsDetails extends StatefulWidget {
  const FeedbackStatisticsDetails({Key key, this.classHeader, this.index})
      : super(key: key);
  final ClassHeader classHeader;
  final int index;

  @override
  _FeedbackStatisticsDetailsState createState() =>
      _FeedbackStatisticsDetailsState();
}

class _FeedbackStatisticsDetailsState extends State<FeedbackStatisticsDetails> {
  static const double barWidth = 30;
  Map<String, FeedbackQuestion> questions;
  List<FeedbackQuestion> lectureQuestions;
  List<FeedbackQuestion> applicationsQuestions;

  Future<void> fetchInfo() async {
    final ClassProvider classProvider =
        Provider.of<ClassProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);
    questions = await feedbackProvider.fetchQuestions();

    lectureQuestions = questions.values
        .where((element) => element.category == '3_lecture')
        .toList();
    applicationsQuestions = questions.values
        .where((element) => element.category == '4_applications')
        .toList();

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  Widget barChart(String question, String questionId) {
    final FeedbackProvider feedbackProvider =
        Provider.of<FeedbackProvider>(context);

    return InfoCard(
      padding: const EdgeInsets.all(0),
      future: feedbackProvider.getQuestionRating(
          widget.classHeader?.id, questionId),
      title: question,
      builder: (occurrences) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: Map<int, int>.from(occurrences)
                      .values
                      .reduce(max)
                      .toDouble() +
                  5,
              groupsSpace: 18,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  margin: 10,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return '0';
                      case 1:
                        return '1';
                      case 2:
                        return '2';
                      case 3:
                        return '3';
                      case 4:
                        return '4';
                      default:
                        return '';
                    }
                  },
                  getTextStyles: (_) => TextStyle(
                    fontSize: 12,
                    color:
                        DynamicTheme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTitles: (double value) {
                    return '${value.toInt()}';
                  },
                  interval: 5,
                  margin: 8,
                  reservedSize: 15,
                  getTextStyles: (_) => TextStyle(
                    fontSize: 12,
                    color:
                        DynamicTheme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 5 == 0,
                getDrawingHorizontalLine: (value) {
                  if (value == 0) {
                    return FlLine(
                        color: const Color(0xff363753), strokeWidth: 3);
                  }
                  return FlLine(
                    color: const Color(0xff2a2747),
                    strokeWidth: 0.8,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
              ),
              axisTitleData: FlAxisTitleData(
                bottomTitle: AxisTitle(
                  titleText: S.current.labelRating,
                  reservedSize: 15,
                  margin: 10,
                  showTitle: true,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color:
                        DynamicTheme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                leftTitle: AxisTitle(
                  titleText: S.current.labelAnswers,
                  reservedSize: 2,
                  margin: 10,
                  showTitle: true,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color:
                        DynamicTheme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      y: double.parse(occurrences[0]?.toString() ?? '0'),
                      colors: [Colors.red],
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      y: double.parse(occurrences[1]?.toString() ?? '0'),
                      colors: [Colors.orange],
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      y: double.parse(occurrences[2]?.toString() ?? '0'),
                      colors: [Colors.amber],
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 3,
                  barRods: [
                    BarChartRodData(
                      y: double.parse(occurrences[3]?.toString() ?? '0'),
                      colors: [Colors.lightGreen],
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 4,
                  barRods: [
                    BarChartRodData(
                      y: double.parse(occurrences[4]?.toString() ?? '0'),
                      colors: [Colors.green],
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.navigationStatistics),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(height: 35),
                if (widget.index == 3)
                barChart(
                    lectureQuestions != null
                        ? lectureQuestions
                            .where((element) => element.id == '7')
                            .first
                            .question
                        : '-',
                    '7'),
                if (widget.index == 4)
                  barChart(
                      applicationsQuestions != null
                          ? applicationsQuestions
                          .where((element) => element.id == '12')
                          .first
                          .question
                          : '-',
                      '12'),
                const SizedBox(height: 35),
                if (widget.index == 3)
                barChart(
                    lectureQuestions != null
                        ? lectureQuestions
                            .where((element) => element.id == '8')
                            .first
                            .question
                        : '-',
                    '8'),
                if (widget.index == 4)
                  barChart(
                      applicationsQuestions != null
                          ? applicationsQuestions
                          .where((element) => element.id == '13')
                          .first
                          .question
                          : '-',
                      '13'),
                const SizedBox(height: 35),
                if (widget.index == 4)
                  barChart(
                      applicationsQuestions != null
                          ? applicationsQuestions
                          .where((element) => element.id == '14')
                          .first
                          .question
                          : '-',
                      '14'),
                if (widget.index == 4)
                  const SizedBox(height: 35),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
