import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/view/uni_event_widget.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class TimetablePage extends StatefulWidget {
  TimetablePage({Key key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  TimetableController<UniEventInstance> _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      _controller = TimetableController(
          // TODO: Make initialTimeRange customizable in settings
          initialTimeRange: InitialTimeRange.range(
              startTime: LocalTime(7, 55, 0), endTime: LocalTime(20, 5, 0)),
          eventProvider: Provider.of<UniEventProvider>(context));
    }

    return AppScaffold(
      title: S.of(context).navigationTimetable,
      needsToBeAuthenticated: true,
      leading: AppScaffoldAction(
        icon: Icons.today,
        onPressed: () => _controller.animateToToday(),
        tooltip: S.of(context).actionJumpToToday,
      ),
      actions: [
        AppScaffoldAction(
          icon: Icons.class_,
          tooltip: S.of(context).navigationClasses,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: Provider.of<ClassProvider>(context),
                child: ClassesPage()),
          )),
        ),
      ],
      body: Timetable<UniEventInstance>(
        controller: _controller,
        eventBuilder: (event) => UniEventWidget(event),
        allDayEventBuilder: (context, event, info) => UniAllDayEventWidget(
          event,
          info: info,
          onTap: () {},
        ),
      ),
    );
  }
}
