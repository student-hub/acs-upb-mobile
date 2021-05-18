import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/event_list_tile.dart';

class ClassEventsCard extends StatefulWidget {
  const ClassEventsCard(this.currentClassId, {Key key}) : super(key: key);
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
      padding: EdgeInsets.zero,
      future: eventProvider.getAllEventsOfClass(widget.currentClassId),
      builder: (events) => Column(
        children: events
            .map(
              (event) => EventListTile(
                uniEvent: event,
              ),
            )
            .toList(),
      ),
    );
  }
}
