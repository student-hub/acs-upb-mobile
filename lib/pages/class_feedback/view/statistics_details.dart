import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:provider/provider.dart';

class FeedbackStatisticsDetails extends StatefulWidget {
  @override
  _FeedbackStatisticsDetailsState createState() =>
      _FeedbackStatisticsDetailsState();
}

class _FeedbackStatisticsDetailsState extends State<FeedbackStatisticsDetails> {
  static const double barWidth = 30;

  Widget barChart() {
    final UniEventProvider eventProvider =
        Provider.of<UniEventProvider>(context);

    return InfoCard(
      future: eventProvider.getUpcomingEvents(LocalDate.today()),
      title: 'Question',
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
                  getTextStyles: (_) => const TextStyle(
                    fontSize: 12,
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
                  getTextStyles: (_) => const TextStyle(
                    fontSize: 12,
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
                  titleText: 'Rating',
                  reservedSize: 15,
                  margin: 10,
                  showTitle: true,
                  textStyle: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                leftTitle: AxisTitle(
                  titleText: 'Answers',
                  reservedSize: 2,
                  margin: 10,
                  showTitle: true,
                  textStyle: const TextStyle(
                    fontSize: 16,
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('Statistics'),
      body: ListView(
        children: [
          barChart(),
          const SizedBox(height: 20),
          barChart(),
          const SizedBox(height: 20),
          barChart(),
          const SizedBox(height: 20),
          barChart(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
