import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../widgets/info_card.dart';
import '../timetable/model/events/uni_event.dart';
import '../timetable/service/uni_event_provider.dart';
import '../timetable/view/events/event_view.dart';

class UpcomingEventsCard extends StatelessWidget {
  const UpcomingEventsCard({final Key key, this.onShowMore}) : super(key: key);
  final void Function() onShowMore;

  @override
  Widget build(final BuildContext context) {
    final UniEventProvider eventProvider =
        Provider.of<UniEventProvider>(context);

    return InfoCard<Iterable<UniEventInstance>>(
      title: S.current.sectionEventsComingUp,
      onShowMore: onShowMore,
      future: eventProvider.getUpcomingEvents(DateTime.now()),
      builder: (final events) => Column(
        children: events
            .map(
              (final event) => ListTile(
                key: ValueKey(event.mainEvent.id),
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
                trailing: event.start.isBefore(DateTime.now())
                    ? Chip(label: Text(S.current.labelNow))
                    : null,
                title: Text(
                  '${'${event.mainEvent.classHeader.acronym} - '}${event.mainEvent.type.toLocalizedString()}',
                ),
                subtitle: Text(event.relativeDateString),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute<EventView>(
                  builder: (final _) => EventView(eventInstance: event),
                )),
              ),
            )
            .toList(),
      ),
    );
  }
}
