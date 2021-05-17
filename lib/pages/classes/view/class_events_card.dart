import 'package:acs_upb_mobile/pages/timetable/model/events/recurring_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/event_view.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

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
              (event) => ListTile(
                key: ValueKey(event.id),
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
                title: Text(event.type.toLocalizedString()),
                subtitle: (event is RecurringUniEvent &&
                        LocaleProvider.rruleL10n != null)
                    ? Text(
                        event.rrule.toText(l10n: LocaleProvider.rruleL10n),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Theme.of(context).hintColor),
                      )
                    : Text(
                        event.start.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Theme.of(context).hintColor),
                      ),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute<EventView>(
                  builder: (_) => EventView(uniEvent: event),
                )),
              ),
            )
            .toList(),
      ),
    );
  }
}
