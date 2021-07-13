import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/class_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/add_event_view.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

class EventView extends StatelessWidget {
  const EventView({Key key, this.eventInstance, this.uniEvent})
      : assert(
            (eventInstance != null && uniEvent == null) ||
                (eventInstance == null && uniEvent != null),
            'Only one of the parameters must be provided'),
        super(key: key);

  final UniEventInstance eventInstance;
  final UniEvent uniEvent;

  static const String routeName = '/event';

  Padding _colorIcon() => Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: uniEvent?.color ?? eventInstance.color),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUserFromCache;
    final UniEvent mainEvent =
        eventInstance?.mainEvent ?? uniEvent;

    return AppScaffold(
      title: Text(S.current.navigationEventDetails),
      actions: [
        AppScaffoldAction(
          icon: Icons.edit_outlined,
          disabled: !mainEvent.editable || !user.canAddPublicInfo,
          onPressed: () {
            if (!mainEvent.editable) {
              AppToast.show(S.current.warningEventNotEditable);
            } else if (!user.canAddPublicInfo) {
              AppToast.show(S.current.errorPermissionDenied);
            } else {
              Navigator.of(context).push(MaterialPageRoute<AddEventView>(
                builder: (_) => ChangeNotifierProvider<FilterProvider>(
                  create: (_) => FilterProvider(
                    defaultDegree: mainEvent.degree,
                    defaultRelevance: mainEvent.relevance,
                  ),
                  child: AddEventView(
                    initialEvent: mainEvent,
                  ),
                ),
              ));
            }
          },
        )
      ],
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
                          eventInstance?.title ??
                              mainEvent.type.toLocalizedString(),
                          style: Theme.of(context).textTheme.headline6),
                      const SizedBox(height: 4),
                      if (eventInstance != null)
                        Text(eventInstance.dateString),
                      if (mainEvent.info != eventInstance?.dateString)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            mainEvent.info,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Theme.of(context).hintColor),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (mainEvent?.classHeader != null)
            ClassListItem(
              classHeader: mainEvent.classHeader,
              hint: S.current.messageTapForMoreInfo,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<ChangeNotifierProvider>(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: Provider.of<ClassProvider>(context),
                    child: ClassView(
                      classHeader: mainEvent.classHeader,
                    ),
                  ),
                ),
              ),
            ),
          if (eventInstance?.location?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(FeatherIcons.mapPin),
                  ),
                  const SizedBox(width: 16),
                  Text(eventInstance?.location,
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(FeatherIcons.users),
                ),
                const SizedBox(width: 16),
                Text(
                    mainEvent.relevance == null
                        ? S.current.relevanceAnyone
                        : '${FilterNode.localizeName(mainEvent.degree, context)}: ${mainEvent.relevance.join(', ')}',
                    style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
          ),
          if (mainEvent is ClassEvent)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: GestureDetector(
                onTap: () {
                  if (mainEvent.teacher != null) {
                    showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext buildContext) =>
                            PersonView(person: mainEvent.teacher));
                  }
                },
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(FeatherIcons.user),
                    ),
                    const SizedBox(width: 16),
                    Text(mainEvent.teacher.name ?? S.current.labelUnknown,
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ),
            ),
        ]),
      ),
    );
  }

  static Widget fromId(BuildContext context, String id) {
    final Future<UniEventInstance> mainEvent =
        Provider.of<UniEventProvider>(context, listen: false)
            .getUpcomingEventsById(LocalDate.today(), id);

    return FutureBuilder(
      future: mainEvent,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final UniEventInstance event = snapshot.data;
          return EventView(
            eventInstance: event,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
