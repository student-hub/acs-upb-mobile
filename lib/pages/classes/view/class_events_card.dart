import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/event_view.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

class ClassEventsCard extends StatelessWidget {
  const ClassEventsCard({Key key, this.currentClass}) : super(key: key);
  final String currentClass;

  @override
  Widget build(BuildContext context) {
    final UniEventProvider eventProvider =
        Provider.of<UniEventProvider>(context);

    return InfoCard<Iterable<UniEventInstance>>(
      title: S.current.sectionEventsComingUp,
      edgeInsets: EdgeInsets.zero,
      future: eventProvider.getUpcomingEvents(LocalDate.today()),
      builder: (events) => Column(
        children: events
            .map(
              (event) => ListTile(
                key: ValueKey(event.id),
                contentPadding: EdgeInsets.zero,
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
                    ? Chip(label: Text(S.current.labelNow))
                    : null,
                title: Text(
                  '${'${event.mainEvent.classHeader.acronym} - '}${event.mainEvent.type.toLocalizedString()}',
                ),
                subtitle: Text(event.relativeDateString),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute<EventView>(
                  builder: (_) => EventView(eventInstance: event),
                )),
              ),
            )
            .toList(),
      ),
    );
  }
}
