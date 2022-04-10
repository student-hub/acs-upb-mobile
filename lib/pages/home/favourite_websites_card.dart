import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentication/service/auth_provider.dart';
import '../../generated/l10n.dart';
import '../../resources/utils.dart';
import '../../widgets/info_card.dart';
import '../portal/model/website.dart';
import '../portal/service/website_provider.dart';
import '../portal/view/website_view.dart';

class FavouriteWebsitesCard extends StatelessWidget {
  const FavouriteWebsitesCard({final Key key, this.onShowMore}) : super(key: key);

  final void Function() onShowMore;

  @override
  Widget build(final BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final String uid = authProvider.uid;
    final WebsiteProvider websiteProvider =
        Provider.of<WebsiteProvider>(context);
    return InfoCard<List<Website>>(
      title: S.current.sectionFrequentlyAccessedWebsites,
      onShowMore: onShowMore,
      future: websiteProvider.fetchFavouriteWebsites(uid),
      builder: (final websites) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: websites
              .map((final website) => Expanded(
                    child: WebsiteIcon(
                      website: website,
                      onTap: () {
                        websiteProvider.incrementNumberOfVisits(website,
                            uid: uid);
                        Utils.launchURL(website.link);
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
