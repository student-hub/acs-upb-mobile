import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/class_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/recurring_event.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/add_event_view.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class EventView extends StatefulWidget {
  const EventView({Key key, this.eventInstance}) : super(key: key);

  final UniEventInstance eventInstance;

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
            color: widget.eventInstance.color,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUserFromCache;
    return AppScaffold(
      title: Text(S.of(context).navigationEventDetails),
      actions: [
        AppScaffoldAction(
          icon: Icons.edit_outlined,
          disabled: !widget.eventInstance.mainEvent.editable ||
              !user.canAddPublicInfo,
          onPressed: () {
            if (!widget.eventInstance.mainEvent.editable) {
              AppToast.show(S.of(context).warningEventNotEditable);
            } else if (!user.canAddPublicInfo) {
              AppToast.show(S.of(context).errorPermissionDenied);
            } else {
              Navigator.of(context).push(MaterialPageRoute<AddEventView>(
                builder: (_) => ChangeNotifierProvider<FilterProvider>(
                  create: (_) => FilterProvider(
                    defaultDegree: widget.eventInstance.mainEvent.degree,
                    defaultRelevance: widget.eventInstance.mainEvent.relevance,
                  ),
                  child: AddEventView(
                    initialEvent: widget.eventInstance.mainEvent,
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
                          widget.eventInstance.title ??
                              widget.eventInstance.mainEvent.type
                                  .toLocalizedString(context),
                          style: Theme.of(context).textTheme.headline6),
                      const SizedBox(height: 4),
                      Text(widget.eventInstance.dateString),
                      if (widget.eventInstance.mainEvent is RecurringUniEvent &&
                          LocaleProvider.rruleL10n != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            (widget.eventInstance.mainEvent
                                    as RecurringUniEvent)
                                .rrule
                                .toText(l10n: LocaleProvider.rruleL10n),
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
          if (widget.eventInstance.mainEvent?.classHeader != null)
            ClassListItem(
              classHeader: widget.eventInstance.mainEvent.classHeader,
              hint: S.of(context).messageTapForMoreInfo,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute<ChangeNotifierProvider>(
                builder: (context) => ChangeNotifierProvider.value(
                  value: Provider.of<ClassProvider>(context),
                  child: ClassView(
                      classHeader: widget.eventInstance.mainEvent.classHeader),
                ),
              )),
            ),
          if (widget.eventInstance.location?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(FeatherIcons.mapPin),
                  ),
                  const SizedBox(width: 16),
                  Text(widget.eventInstance.location,
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
          if (widget.eventInstance.mainEvent != null)
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
                      widget.eventInstance.mainEvent.relevance == null
                          ? S.of(context).relevanceAnyone
                          : '${FilterNode.localizeName(widget.eventInstance.mainEvent.degree, context)}: ${widget.eventInstance.mainEvent.relevance.join(', ')}',
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
          if (widget.eventInstance.mainEvent is ClassEvent)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: GestureDetector(
                onTap: () {
                  if ((widget.eventInstance.mainEvent as ClassEvent).teacher !=
                      null) {
                    showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext buildContext) => PersonView(
                            person:
                                (widget.eventInstance.mainEvent as ClassEvent)
                                    .teacher));
                  }
                },
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(FeatherIcons.user),
                    ),
                    const SizedBox(width: 16),
                    Text(
                        (widget.eventInstance.mainEvent as ClassEvent)
                                .teacher
                                .name ??
                            S.of(context).labelUnknown,
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
