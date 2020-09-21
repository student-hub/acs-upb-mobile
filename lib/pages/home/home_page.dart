import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final TabController tabController;

  HomePage({this.tabController, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).navigationHome,
      actions: [
        AppScaffoldAction(
          icon: Icons.settings,
          tooltip: S.of(context).navigationSettings,
          route: Routes.settings,
        )
      ],
      body: ListView(
        children: [
          favouriteWebsites(context),
        ],
      ),
    );
  }

  Padding favouriteWebsites(BuildContext context) {
    var websites = Provider.of<WebsiteProvider>(context, listen: false)
        .fetchWebsites(null);

    return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: FutureBuilder(
            future: websites,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Website> websitesData = snapshot.data;
                websitesData.sort((website1, website2) =>
                    website2.numberOfVisits.compareTo(website1.numberOfVisits));
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).sectionFrequentlyAccessedWebsites,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontSize: 18),
                            ),
                            GestureDetector(
                              onTap: () => tabController?.animateTo(2),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    S.of(context).actionShowMore,
                                    style: Theme.of(context)
                                        .accentTextTheme
                                        .subtitle2
                                        .copyWith(
                                            color:
                                                Theme.of(context).accentColor),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).accentColor,
                                    size: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .fontSize,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        //if (isMainUser(context))
                        if (websitesData.first.numberOfVisits == 0)
                          noneYet(context)
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: websitesData
                                .take(3)
                                .map((website) => Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FutureBuilder<
                                            ImageProvider<dynamic>>(
                                          future: Provider.of<StorageProvider>(
                                                  context,
                                                  listen: false)
                                              .imageFromPath(website.iconPath),
                                          builder: (context, snapshot) {
                                            ImageProvider<dynamic> image =
                                                AssetImage(
                                                    'assets/icons/websites/globe.png');
                                            if (snapshot.hasData) {
                                              image = snapshot.data;
                                            }
                                            return CircleImage(
                                              label: website.label,
                                              onTap: () {
                                                Provider.of<WebsiteProvider>(
                                                        context,
                                                        listen: false)
                                                    .incrementNumberOfVisits(
                                                        website);
                                                Utils.launchURL(website.link,
                                                    context: context);
                                              },
                                              image: image,
                                              tooltip: website.infoByLocale[
                                                  LocaleProvider.localeString],
                                            );
                                          },
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  bool isMainUser(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return authProvider.uid == 'P1Ziec4xuEOjem3NIMWzyTfORTU2';
  }

  Widget noneYet(BuildContext context) => Container(
      height: 100,
      child: Center(
          child: Text(
        S.of(context).warningNoneYet,
        style: TextStyle(color: Theme.of(context).disabledColor),
      )));
}
