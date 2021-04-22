import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:timetable/src/event.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

extension EventExtension on Event {
  String dateStringRelativeToToday(BuildContext context) {
    final LocalDateTime end = this.end.clockTime.equals(LocalTime(00, 00, 00))
        ? this.end.subtractDays(1)
        : this.end;

    String string = start.calendarDate.equals(LocalDate.today())
        ? S.of(context).labelToday
        : start.calendarDate.subtractDays(1).equals(LocalDate.today())
            ? S.of(context).labelTomorrow
            : start.calendarDate.toString('dddd, dd MMMM');

    if (!start.clockTime.equals(LocalTime(00, 00, 00))) {
      string += ' • ${start.clockTime.toString('HH:mm')}';
    }
    if (start.calendarDate != end.calendarDate) {
      string += ' - ${end.calendarDate.toString('dddd, dd MMMM')}';
    }
    if (!end.clockTime.equals(LocalTime(00, 00, 00))) {
      if (start.calendarDate != end.calendarDate) {
        string += ' • ';
      } else {
        string += '-';
      }
      string += end.clockTime.toString('HH:mm');
    }
    return string;
  }
}

class UpcomingEventsCard extends StatelessWidget {
  const UpcomingEventsCard({Key key, this.onShowMore}) : super(key: key);
  final void Function() onShowMore;

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final String uid = authProvider.uid;
    final eventProvider = Provider.of<UniEventProvider>(context);

    return InfoCard<Iterable<UniEventInstance>>(
      title: S.of(context).sectionEventsComingUp,
      onShowMore: onShowMore,
      future: eventProvider.getUpcomingEvents(LocalDate.today()),
      builder: (events) => Column(
        children: events
            .map(
              (event) => ListTile(
                key: ValueKey(event.mainEvent.id),
                leading: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: event.mainEvent.color,
                    ),
                  ),
                ),
                trailing: event.start.toDateTimeLocal().isBefore(DateTime.now())
                    ? Chip(label: Text(S.of(context).labelNow))
                    : null,
                title: Text(
                  '${'${event.mainEvent.classHeader.acronym} - '}${event.mainEvent.type.toLocalizedString(context)}',
                ),
                subtitle: Text(event.dateStringRelativeToToday(context)),
              ),
            )
            .toList(),
      ),
    );
  }
}
