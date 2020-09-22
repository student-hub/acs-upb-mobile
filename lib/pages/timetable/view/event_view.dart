import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timetable/timetable.dart';

extension EventExtension on Event {
  String get dateString {
    if (start.calendarDate == end.calendarDate) {
      return start.calendarDate.toString('dddd, dd MMMM') +
          ' • ' +
          start.clockTime.toString('HH:mm') +
          ' - ' +
          end.clockTime.toString('HH:mm');
    } else {
      return start.calendarDate.toString('dddd, dd MMMM') +
          ' • ' +
          start.clockTime.toString('HH:mm') +
          ' - ' +
          end.calendarDate.toString('dddd, dd MMMM') +
          ' • ' +
          end.clockTime.toString('HH:mm');
    }
  }
}

class EventView extends StatefulWidget {
  final UniEventInstance event;

  const EventView({Key key, this.event}) : super(key: key);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  Padding _colorIcon() => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: widget.event.color,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).navigationEventDetails,
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                _colorIcon(),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        widget.event.mainEvent?.classHeader?.name ??
                            widget.event.title,
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 4),
                    // TODO: Improve date format
                    Text(widget.event.dateString),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.category),
                SizedBox(width: 16),
                Text(widget.event.mainEvent.type.toLocalizedString(context)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.location_on),
                SizedBox(width: 16),
                Text(widget.event.location ?? ''),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
