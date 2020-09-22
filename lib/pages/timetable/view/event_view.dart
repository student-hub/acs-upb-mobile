import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

extension EventExtension on Event {
  String get dateString {
    LocalDateTime end = this.end.clockTime.equals(LocalTime(00, 00, 00))
        ? this.end.subtractDays(1)
        : this.end;

    String string =
        start.calendarDate.toString('dddd, dd MMMM', LocaleProvider.culture);
    if (!start.clockTime.equals(LocalTime(00, 00, 00))) {
      string +=
          ' • ' + start.clockTime.toString('HH:mm', LocaleProvider.culture);
    }
    if (start.calendarDate != end.calendarDate) {
      string += ' - ' +
          end.calendarDate.toString('dddd, dd MMMM', LocaleProvider.culture);
    }
    if (!end.clockTime.equals(LocalTime(00, 00, 00))) {
      if (start.calendarDate != end.calendarDate) {
        string += ' • ';
      } else {
        string += '-';
      }
      string += start.clockTime.toString('HH:mm', LocaleProvider.culture);
    }
    return string;
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
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          widget.event.mainEvent?.classHeader?.name ??
                              widget.event.title,
                          style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: 4),
                      Text(widget.event.dateString),
                    ],
                  ),
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
          if (widget.event.location != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  SizedBox(width: 16),
                  Text(widget.event.location),
                ],
              ),
            ),
        ]),
      ),
    );
  }
}
