import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/event_view.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventInstancesList extends StatefulWidget {
  const EventInstancesList({Key key, this.eventInstance}) : super(key: key);

  final UniEvent eventInstance;

  @override
  _EventInstancesListState createState() => _EventInstancesListState();
}

class _EventInstancesListState extends State<EventInstancesList> {
  Iterable<UniEventInstance> events;
  @override
  Widget build(BuildContext context) {
    final UniEventProvider eventProvider =
        Provider.of<UniEventProvider>(context);
    return AppScaffold(
        title: Text(
            '${'${widget.eventInstance.classHeader.acronym} - '}${widget.eventInstance.type.toLocalizedString()}'),
        body: FutureBuilder(
            future:
                eventProvider.getAllInstancesOfEvent(widget.eventInstance.id),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                events = snapshot.data;
                return ListView(
                  children: events
                      .map(
                        (event) => ListTile(
                          key: ValueKey(event.id),
                          leading: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                color: event.end
                                        .toDateTimeLocal()
                                        .isBefore(DateTime.now())
                                    ? event.color.withOpacity(0.25)
                                    : event.color,
                              ),
                            ),
                          ),
                          title: Text(
                            '${'${event.mainEvent.classHeader.acronym} - '}${event.mainEvent.type.toLocalizedString()}',
                          ),
                          subtitle: Text(event.relativeDateString),
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute<EventView>(
                            builder: (_) => EventView(eventInstance: event),
                          )),
                        ),
                      )
                      .toList(),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
