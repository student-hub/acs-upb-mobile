import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/recurring_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

extension EventExtension on Event {
  String get dateString {
    final LocalDateTime end = this.end.clockTime.equals(LocalTime(00, 00, 00))
        ? this.end.subtractDays(1)
        : this.end;

    String string =
        start.calendarDate.toString('dddd, dd MMMM', LocaleProvider.culture);
    if (!start.clockTime.equals(LocalTime(00, 00, 00))) {
      string +=
          ' • ${start.clockTime.toString('HH:mm', LocaleProvider.culture)}';
    }
    if (start.calendarDate != end.calendarDate) {
      string +=
          ' - ${end.calendarDate.toString('dddd, dd MMMM', LocaleProvider.culture)}';
    }
    if (!end.clockTime.equals(LocalTime(00, 00, 00))) {
      if (start.calendarDate != end.calendarDate) {
        string += ' • ';
      } else {
        string += '-';
      }
      string += end.clockTime.toString('HH:mm', LocaleProvider.culture);
    }
    return string;
  }
}

class EventView extends StatefulWidget {
  const EventView({Key key, this.event}) : super(key: key);

  final UniEventInstance event;

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  Padding _colorIcon() => Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: widget.event.color,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.of(context).navigationEventDetails),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                _colorIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          widget.event.title ??
                              widget.event.mainEvent.type
                                  .toLocalizedString(context),
                          style: Theme.of(context).textTheme.headline6),
                      const SizedBox(height: 4),
                      Text(widget.event.dateString),
                      if (widget.event.mainEvent is RecurringUniEvent &&
                          LocaleProvider.rruleL10n != null)
                        Text((widget.event.mainEvent as RecurringUniEvent)
                            .rrule
                            .toText(l10n: LocaleProvider.rruleL10n)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.event.mainEvent?.classHeader != null)
            ClassListItem(
              classHeader: widget.event.mainEvent.classHeader,
              hint: S.of(context).messageTapForMoreInfo,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute<ChangeNotifierProvider>(
                builder: (context) => ChangeNotifierProvider.value(
                  value: Provider.of<ClassProvider>(context),
                  child: ClassView(
                      classHeader: widget.event.mainEvent.classHeader),
                ),
              )),
            ),
          if (widget.event.location != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.location_on),
                  ),
                  const SizedBox(width: 16),
                  Text(widget.event.location,
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
          if (widget.event.mainEvent != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.people),
                  ),
                  const SizedBox(width: 16),
                  Text(
                      widget.event.mainEvent.relevance == null
                          ? S.of(context).relevanceAnyone
                          : '${widget.event.mainEvent.degree}: ${widget.event.mainEvent.relevance.join(', ')}',
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
        ]),
      ),
    );
  }
}
