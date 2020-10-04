import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/filter/view/filter_page.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/view/date_header.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/all_day_event_widget.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/event_widget.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key key}) : super(key: key);

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
    final eventProvider = Provider.of<UniEventProvider>(context);
    if (_controller == null) {
      _controller = TimetableController(
          // TODO(IoanaAlexandru): Make initialTimeRange customizable in settings
          initialTimeRange: InitialTimeRange.range(
              startTime: LocalTime(7, 55, 0), endTime: LocalTime(20, 5, 0)),
          eventProvider: eventProvider);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) {
          return;
        }

        // Fetch user classes so they're cached
        final user = Provider.of<AuthProvider>(context, listen: false)
            .currentUserFromCache;
        await Provider.of<ClassProvider>(context, listen: false)
            .fetchClassHeaders(uid: user.uid);

        // Slight delay between last frame and dialog
        await Future<void>.delayed(const Duration(milliseconds: 500));

        // Show dialog if there are no events
        if (eventProvider.empty == true) {
          await showDialog<String>(
            context: context,
            builder: buildDialog,
          );
        }
      });
    }

    return AppScaffold(
      title: AnimatedBuilder(
        animation: _controller.dateListenable,
        builder: (context, child) => Text(
            Provider.of<AuthProvider>(context).currentUserFromCache == null
                ? S.of(context).navigationTimetable
                : _controller.currentMonth.titleCase),
      ),
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
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<ChangeNotifierProvider>(
              builder: (_) => ChangeNotifierProvider.value(
                  value: Provider.of<ClassProvider>(context),
                  child: const ClassesPage()),
            ),
          ),
        ),
        AppScaffoldAction(
          icon: CustomIcons.filter,
          tooltip: S.of(context).navigationFilter,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<FilterPage>(builder: (_) => const FilterPage()),
          ),
        ),
      ],
      body: Stack(
        children: [
          Timetable<UniEventInstance>(
            controller: _controller,
            dateHeaderBuilder: (_, date) => DateHeader(date),
            eventBuilder: (event) => UniEventWidget(event),
            allDayEventBuilder: (context, event, info) => UniAllDayEventWidget(
              event,
              info: info,
            ),
          ),
          if (eventProvider.eventsCache == null)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget buildDialog(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUserFromCache;

    if (classProvider.userClassHeadersCache?.isEmpty ?? true) {
      return AppDialog(
        title: S.of(context).warningNoEvents,
        content: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1,
              children: [
                TextSpan(text: '${S.of(context).infoYouNeedToSelect} '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: Icon(
                    Icons.class_,
                    size: Theme.of(context).textTheme.subtitle1.fontSize + 2,
                  ),
                ),
                TextSpan(text: ' ${S.of(context).infoClasses}.'),
              ],
            ),
          ),
        ],
        actions: [
          AppButton(
            text: S.of(context).actionChooseClasses,
            width: 130,
            onTap: () async {
              // Pop the dialog
              Navigator.of(context).pop();
              // Push the Add classes page
              await Navigator.of(context)
                  .push(MaterialPageRoute<ChangeNotifierProvider>(
                builder: (_) => ChangeNotifierProvider.value(
                    value: classProvider,
                    child: FutureBuilder(
                      future: classProvider.fetchUserClassIds(
                          uid: user.uid, context: context),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return AddClassesPage(
                              initialClassIds: snap.data,
                              onSave: (classIds) async {
                                await classProvider.setUserClassIds(
                                    classIds: classIds, uid: authProvider.uid);
                                Navigator.pop(context);
                              });
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )),
              ));
            },
          )
        ],
      );
    } else {
      return AppDialog(
        title: S.of(context).warningNoEvents,
        content: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1,
              children: [
                TextSpan(text: '${S.of(context).infoMakeSureGroupIsSelected} '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: Icon(
                    CustomIcons.filter,
                    size: Theme.of(context).textTheme.subtitle1.fontSize + 2,
                  ),
                ),
                TextSpan(
                    text: ' ${S.of(context).navigationFilter.toLowerCase()}.'),
              ],
            ),
          ),
        ],
        actions: [
          AppButton(
            text: S.of(context).actionOpenFilter,
            width: 130,
            onTap: () async {
              // Pop the dialog
              Navigator.of(context).pop();
              // Push the Filter page
              await Navigator.pushNamed(context, Routes.filter);
            },
          )
        ],
      );
    }
  }
}

extension MonthController on TimetableController {
  String get currentMonth =>
      LocalDateTime(2020, dateListenable.value.monthOfYear, 1, 1, 1, 1)
          .toString('MMMM');
}
