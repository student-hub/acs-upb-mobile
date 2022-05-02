import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/event_list_tile.dart';
import '../../../widgets/info_card.dart';
import '../../timetable/model/events/uni_event.dart';
import '../../timetable/service/uni_event_provider.dart';

class ClassEventsCard extends StatefulWidget {
  const ClassEventsCard(this.currentClassId, {final Key key}) : super(key: key);
  final String currentClassId;

  @override
  _ClassEventsCardState createState() => _ClassEventsCardState();
}

class _ClassEventsCardState extends State<ClassEventsCard> {
  @override
  Widget build(final BuildContext context) {
    final UniEventProvider eventProvider =
        Provider.of<UniEventProvider>(context);
    return InfoCard<Iterable<UniEvent>>(
      title: S.of(context).sectionEvents,
      padding: EdgeInsets.zero,
      future: eventProvider.getAllEventsOfClass(widget.currentClassId),
      builder: (final events) => Column(
        children: events
            .map(
              (final event) => EventListTile(
                uniEvent: event,
              ),
            )
            .toList(),
      ),
    );
  }
}
