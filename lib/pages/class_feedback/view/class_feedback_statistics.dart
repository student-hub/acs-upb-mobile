import 'dart:math';

import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/statistics_details.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:fl_chart/fl_chart.dart' hide PieChart;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/src/pie_chart.dart';

class ClassFeedbackStatistics extends StatefulWidget {
  const ClassFeedbackStatistics({Key key, this.classHeader}) : super(key: key);
  final ClassHeader classHeader;

  @override
  _ClassFeedbackStatisticsState createState() =>
      _ClassFeedbackStatisticsState();
}

class _ClassFeedbackStatisticsState extends State<ClassFeedbackStatistics> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
  static const double barWidth = 30;

  Widget barChart(String category, int index) {
    final FeedbackProvider feedbackProvider =
        Provider.of<FeedbackProvider>(context);

    return InfoCard(
      padding: const EdgeInsets.all(0),
      future: index == 3
          ? feedbackProvider.getLectureRatingOverview(widget.classHeader?.id)
          : feedbackProvider
              .getApplicationsRatingOverview(widget.classHeader?.id),
      onShowMore: () => Navigator.of(context)
          .push(MaterialPageRoute<FeedbackStatisticsDetails>(
              builder: (_) => FeedbackStatisticsDetails(
                    classHeader: widget.classHeader, index: index,
                  ))),
      title: category,
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

  Widget scatterChart() {
    final FeedbackProvider feedbackProvider =
        Provider.of<FeedbackProvider>(context);

    return FutureBuilder(
      future:
          feedbackProvider.getGradeAndHoursCorrelation(widget.classHeader?.id),
      builder:
          (BuildContext context, AsyncSnapshot<Map<int, List<int>>> snapshot) {
        if (snapshot.hasData) {
          final List<ScatterSpot> scatterSpots = [];
          for (final key in snapshot.data.keys) {
            for (final value in snapshot.data[key]) {
              scatterSpots.add(ScatterSpot(key.toDouble(), value.toDouble(),
                  color: Theme.of(context).accentColor));
            }
          }

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.current.sectionGradeVsHours,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ScatterChart(
                      ScatterChartData(
                        scatterSpots: scatterSpots,
                        minX: 1,
                        maxX: 10,
                        minY: 0,
                        maxY: 10,
                        borderData: FlBorderData(
                          show: true,
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          checkToShowHorizontalLine: (value) => true,
                          getDrawingHorizontalLine: (value) => FlLine(
                              color: DynamicTheme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1)),
                          drawVerticalLine: true,
                          checkToShowVerticalLine: (value) => true,
                          getDrawingVerticalLine: (value) => FlLine(
                              color: DynamicTheme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1)),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 3,
                            margin: 10,
                            interval: 2,
                            getTextStyles: (_) => TextStyle(
                              fontSize: 12,
                              color: DynamicTheme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          bottomTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 3,
                            margin: 10,
                            interval: 3,
                            getTextStyles: (_) => TextStyle(
                              fontSize: 12,
                              color: DynamicTheme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        axisTitleData: FlAxisTitleData(
                          bottomTitle: AxisTitle(
                            titleText: S.current.labelGrade,
                            reservedSize: 15,
                            margin: 10,
                            showTitle: true,
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              color: DynamicTheme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          leftTitle: AxisTitle(
                            titleText: S.current.labelHoursWorked,
                            reservedSize: 2,
                            margin: 10,
                            showTitle: true,
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              color: DynamicTheme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        scatterTouchData: ScatterTouchData(
                          enabled: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget pieChart() {
    final FeedbackProvider feedbackProvider =
        Provider.of<FeedbackProvider>(context);

    return InfoCard(
      future: feedbackProvider.getTimeRequiredForExam(widget.classHeader?.id),
      title: 'Time required for exam',
      padding: const EdgeInsets.all(0),
      builder: (dataMap) => PieChart(
        dataMap: dataMap,
        legendPosition: LegendPosition.left,
        legendStyle: Theme.of(context).textTheme.subtitle2,
        chartRadius: 250,
        chartValueStyle: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
        decimalPlaces: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FeedbackProvider feedbackProvider =
        Provider.of<FeedbackProvider>(context);

    return AppScaffold(
      title: Text(S.current.navigationStatistics),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    left: MediaQuery.of(context).size.width / 20,
                    right: MediaQuery.of(context).size.width / 20,
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 120,
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                future: feedbackProvider.getNumberOfResponses(
                                    widget.classHeader?.id),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: const TextStyle(fontSize: 28),
                                    );
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.person_outline),
                                  const SizedBox(width: 5),
                                  Text(
                                    S.current.labelResponses,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          width:
                              7 * MediaQuery.of(context).size.width / 30 - 25),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 120,
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '4.8/5',
                                style: TextStyle(fontSize: 22),
                              ),
                              const SizedBox(height: 17),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.bookOpen),
                                  const SizedBox(width: 10),
                                  Text(
                                    S.current.labelScore,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                scatterChart(),
                const SizedBox(height: 35),
                barChart(S.current.uniEventTypeLecture, 3),
                const SizedBox(height: 35),
                barChart('Applications', 4),
                const SizedBox(height: 35),
                pieChart(),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
