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
    return InfoCard<List<UniEventInstance>>(
      title: S.of(context).sectionFrequentlyAccessedWebsites,
      onShowMore: onShowMore,
      future: eventProvider.getUpcomingEvents(LocalDate.today()),
      //future: websiteProvider.fetchFavouriteWebsites(uid: uid, context: context),
      builder: (events) => Column(
        children: events
            .map(
              (event) => ListTile(
                key: ValueKey(event.mainEvent.id),
                title: Text(
                  event.mainEvent.name,
                ),
                subtitle: Text(event.mainEvent.id),
              ),
            )
            .toList(),
      ),
    );
  }
}
