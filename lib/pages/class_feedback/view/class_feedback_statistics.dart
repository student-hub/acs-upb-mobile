import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:time_machine/time_machine.dart';
import 'package:provider/provider.dart';

class ClassFeedbackStatistics extends StatefulWidget {
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
  List<int> selectedSpots = [];
  Color greyColor = Colors.grey;
  static const double barWidth = 22;

  Widget firstGraph() {
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
  }

  Widget barChart() {
    final UniEventProvider eventProvider =
    Provider.of<UniEventProvider>(context);

    return InfoCard(
      future: eventProvider.getUpcomingEvents(LocalDate.today()),
      onShowMore: () => Navigator.of(context).pop(),
      title: S.current.sectionEventsComingUp,
      builder: (_) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                maxY: 20,
                groupsSpace: 12,
                barTouchData: BarTouchData(
                  enabled: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: SideTitles(
                    showTitles: true,
                    margin: 10,
                    rotateAngle: 0,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'Mon';
                        case 1:
                          return 'Tue';
                        case 2:
                          return 'Wed';
                        case 3:
                          return 'Thu';
                        case 4:
                          return 'Fri';
                        case 5:
                          return 'Sat';
                        case 6:
                          return 'Sun';
                        default:
                          return '';
                      }
                    },
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    margin: 10,
                    rotateAngle: 0,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'Mon';
                        case 1:
                          return 'Tue';
                        case 2:
                          return 'Wed';
                        case 3:
                          return 'Thu';
                        case 4:
                          return 'Fri';
                        case 5:
                          return 'Sat';
                        case 6:
                          return 'Sun';
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    rotateAngle: 45,
                    getTitles: (double value) {
                      if (value == 0) {
                        return '0';
                      }
                      return '${value.toInt()}0k';
                    },
                    interval: 5,
                    margin: 8,
                    reservedSize: 30,
                  ),
                  rightTitles: SideTitles(
                    showTitles: true,
                    rotateAngle: 90,
                    getTitles: (double value) {
                      if (value == 0) {
                        return '0';
                      }
                      return '${value.toInt()}0k';
                    },
                    interval: 5,
                    margin: 8,
                    reservedSize: 30,
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
                  show: false,
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        y: 15.1,
                        width: barWidth,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        rodStackItem: [
                          BarChartRodStackItem(0, 2, const Color(0xff2bdb90)),
                          BarChartRodStackItem(2, 5, const Color(0xffffdd80)),
                          BarChartRodStackItem(5, 7.5, const Color(0xffff4d94)),
                          BarChartRodStackItem(
                              7.5, 15.5, const Color(0xff19bfff)),
                        ],
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        y: 13,
                        width: barWidth,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        rodStackItem: [
                          BarChartRodStackItem(0, 1.5, const Color(0xff2bdb90)),
                          BarChartRodStackItem(
                              1.5, 3.5, const Color(0xffffdd80)),
                          BarChartRodStackItem(3.5, 7, const Color(0xffff4d94)),
                          BarChartRodStackItem(7, 13, const Color(0xff19bfff)),
                        ],
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        y: 13.5,
                        width: barWidth,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        rodStackItem: [
                          BarChartRodStackItem(0, 1.5, const Color(0xff2bdb90)),
                          BarChartRodStackItem(1.5, 3, const Color(0xffffdd80)),
                          BarChartRodStackItem(3, 7, const Color(0xffff4d94)),
                          BarChartRodStackItem(
                              7, 13.5, const Color(0xff19bfff)),
                        ],
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 6,
                    barRods: [
                      BarChartRodData(
                        y: 16,
                        width: barWidth,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        rodStackItem: [
                          BarChartRodStackItem(0, 1.2, const Color(0xff2bdb90)),
                          BarChartRodStackItem(1.2, 6, const Color(0xffffdd80)),
                          BarChartRodStackItem(6, 11, const Color(0xffff4d94)),
                          BarChartRodStackItem(11, 17, const Color(0xff19bfff)),
                        ],
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
            ScatterChart(
              ScatterChartData(
                scatterSpots: [
                  ScatterSpot(
                    4,
                    4,
                    color: selectedSpots.contains(0) ? Colors.green : greyColor,
                  ),
                  ScatterSpot(
                    2,
                    5,
                    color:
                        selectedSpots.contains(1) ? Colors.yellow : greyColor,
                    radius: 12,
                  ),
                  ScatterSpot(
                    4,
                    5,
                    color: selectedSpots.contains(2)
                        ? Colors.purpleAccent
                        : greyColor,
                    radius: 8,
                  ),
                  ScatterSpot(
                    8,
                    6,
                    color:
                        selectedSpots.contains(3) ? Colors.orange : greyColor,
                    radius: 20,
                  ),
                  ScatterSpot(
                    5,
                    7,
                    color: selectedSpots.contains(4) ? Colors.brown : greyColor,
                    radius: 14,
                  ),
                  ScatterSpot(
                    7,
                    2,
                    color: selectedSpots.contains(5)
                        ? Colors.lightGreenAccent
                        : greyColor,
                    radius: 18,
                  ),
                  ScatterSpot(
                    3,
                    2,
                    color: selectedSpots.contains(6) ? Colors.red : greyColor,
                    radius: 36,
                  ),
                  ScatterSpot(
                    2,
                    8,
                    color: selectedSpots.contains(7)
                        ? Colors.tealAccent
                        : greyColor,
                    radius: 22,
                  ),
                ],
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 10,
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  checkToShowHorizontalLine: (value) => true,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.white.withOpacity(0.1)),
                  drawVerticalLine: true,
                  checkToShowVerticalLine: (value) => true,
                  getDrawingVerticalLine: (value) =>
                      FlLine(color: Colors.white.withOpacity(0.1)),
                ),
                titlesData: FlTitlesData(
                  show: false,
                ),
              ),
              swapAnimationDuration: Duration(milliseconds: 150),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.navigationClassFeedback),
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
                              Icon(Icons.person_outline),
                              const SizedBox(height: 10),
                              Text('Responses'),
                              const SizedBox(height: 10),
                              Text('93'),
                              const SizedBox(height: 10),
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
                              Icon(FeatherIcons.bookOpen),
                              const SizedBox(height: 10),
                              Text('Score'),
                              const SizedBox(height: 10),
                              Text('4.8/5'),
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
          color: isTouched ? [Colors.yellow] : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            color: barBackgroundColor,
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
