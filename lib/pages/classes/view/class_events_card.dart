import 'package:acs_upb_mobile/pages/timetable/model/events/recurring_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

import 'event_instances_list.dart';

class ClassEventsCard extends StatefulWidget {
  const ClassEventsCard({Key key, this.currentClassId}) : super(key: key);
  final String currentClassId;

  @override
  _ClassEventsCardState createState() => _ClassEventsCardState();
}

class _ClassEventsCardState extends State<ClassEventsCard> {
  @override
  Widget build(BuildContext context) {
    final UniEventProvider eventProvider =
        Provider.of<UniEventProvider>(context);

    return InfoCard<Iterable<UniEvent>>(
      title: S.of(context).sectionEvents,
      edgeInsets: EdgeInsets.zero,
      future: eventProvider.getAllClassesEvents(widget.currentClassId),
      builder: (events) => Column(
        children: events
            .map(
              (event) => ListTile(
                key: ValueKey(event.id),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                leading: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: event.color,
                    ),
                  ),
                ),
                title: Text(
                  '${'${event.classHeader.acronym} - '}${event.type.toLocalizedString()}',
                ),
                subtitle: (event is RecurringUniEvent &&
                        LocaleProvider.rruleL10n != null)
                    ? Text(
                        event.rrule.toText(l10n: LocaleProvider.rruleL10n),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Theme.of(context).hintColor),
                      )
                    : null,
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute<EventInstancesList>(
                  builder: (_) => EventInstancesList(eventInstance: event),
                )),
              ),
            )
            .toList(),
      ),
    );
  }
}
