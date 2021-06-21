import 'package:acs_upb_mobile/pages/class_feedback/service/feedback_provider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/statistics_details.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

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

  /*Widget firstGraph() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.sectionGrading,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                ),
                child: LineChart(
                  mainData(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  Widget barChart() {
    final FeedbackProvider feedbackProvider =
        Provider.of<FeedbackProvider>(context);

    return InfoCard(
      padding: const EdgeInsets.all(0),
      future:
          feedbackProvider.getGradeAndHoursCorrelation(widget.classHeader?.id),
      onShowMore: () => Navigator.of(context).push(
          MaterialPageRoute<FeedbackStatisticsDetails>(
              builder: (_) => FeedbackStatisticsDetails())),
      title: S.current.uniEventTypeLecture,
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: 50,
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
                  interval: 15,
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
                      y: 15,
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
                      y: 16,
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
                      y: 25,
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
                      y: 30,
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
                      y: 46,
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
                    top: 20,
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
                            children: [
                              const SizedBox(height: 10),
                              const Icon(Icons.person_outline),
                              const SizedBox(height: 10),
                              Text(S.current.labelResponses),
                              const SizedBox(height: 10),
                              FutureBuilder(
                                future: feedbackProvider.getNumberOfResponses(
                                    widget.classHeader?.id),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data.toString());
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 6),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 120,
                        child: Card(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Icon(FeatherIcons.bookOpen),
                              const SizedBox(height: 10),
                              Text(S.current.labelScore),
                              const SizedBox(height: 10),
                              const Text('4.8/5'),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                scatterChart(),
                const SizedBox(height: 24),
                barChart(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.blue,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 9, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                '$weekDay\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is PointerUpEvent &&
                barTouchResponse.touchInput is PointerExitEvent) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
              case 5:
                return '5';
              case 6:
                return '6';
              case 7:
                return '7';
              case 8:
                return '8';
              case 9:
                return '9';
              case 10:
                return '10';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
              case 5:
                return '5';
              case 6:
                return '6';
              case 7:
                return '7';
              case 8:
                return '8';
              case 9:
                return '9';
              case 10:
                return '10';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 1,
      maxX: 10,
      minY: 1,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(2, 5),
            FlSpot(3, 6),
            FlSpot(4, 5),
            FlSpot(5, 9),
            FlSpot(5, 3),
            FlSpot(8, 8),
            FlSpot(9, 7),
            FlSpot(10, 10),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
