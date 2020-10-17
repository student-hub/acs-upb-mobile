import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/pages/portal/view/website_view.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteWebsitesCard extends StatelessWidget {
  const FavouriteWebsitesCard({Key key, this.onShowMore}) : super(key: key);

  final void Function() onShowMore;

  @override
  Widget build(BuildContext context) {
    final String userId = Provider.of<AuthProvider>(context, listen: false).uid;
    final WebsiteProvider websiteProvider =
        Provider.of<WebsiteProvider>(context);
    return InfoCard<List<Website>>(
      title: S.of(context).sectionFrequentlyAccessedWebsites,
      onShowMore: onShowMore,
      future: websiteProvider.fetchFavouriteWebsites(userId),
      builder: (websites) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: websites
            .map((website) => Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: WebsiteIcon(
                        website: website,
                        onTap: () {
                          Provider.of<WebsiteProvider>(context, listen: false)
                              .incrementNumberOfVisits(
                                  website,
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .uid);
                          Utils.launchURL(website.link, context: context);
                        },
                      )),
                ))
            .toList(),
      ),
    );
  }
}
