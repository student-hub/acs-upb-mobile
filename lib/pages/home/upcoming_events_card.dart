import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

class UpcomingEventsCard extends StatelessWidget {
  const UpcomingEventsCard({Key key, this.onShowMore}) : super(key: key);
  final void Function() onShowMore;

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final String uid = authProvider.uid;
    final eventProvider = Provider.of<UniEventProvider>(context);
    final WebsiteProvider websiteProvider =
        Provider.of<WebsiteProvider>(context);

    Padding _colorIcon(event) => Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Colors.blueGrey,
            ),
          ),
        );
    return InfoCard<Iterable<UniEventInstance>>(
      title: S.of(context).sectionFrequentlyAccessedWebsites,
      onShowMore: onShowMore,
      future: eventProvider.getUpcomingEvents(LocalDate.today()),
      //future: websiteProvider.fetchFavouriteWebsites(uid: uid, context: context),
      builder: (events) => Column(
        children: [
              ListTile(
                key: ValueKey(events.first.mainEvent.id),
                title: Text(
                  events.first.mainEvent.classHeader.acronym,
                ),
                subtitle: Text(events.first.start.toString()),
              )
            ] +
            events
                .map(
                  (event) => ListTile(
                    key: ValueKey(event.mainEvent.id + "212"),
                    title: Text(
                      event.mainEvent.classHeader.acronym,
                    ),
                    subtitle: Text(event.start.toString()),
                  ),
                )
                .toList(),
      ),
    );
  }
}
