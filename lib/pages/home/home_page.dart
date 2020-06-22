import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  final TabController tabController;

  HomePage(this.tabController);

  _launchURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppToast.show(S.of(context).errorCouldNotLaunchURL(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    var websites = [
      Website(
        id: '1',
        relevance: null,
        category: WebsiteCategory.learning,
        iconPath: 'icons/websites/moodle.png',
        infoByLocale: {'en': 'info-en', 'ro': 'info-ro'},
        label: 'Moodle',
        link: 'http://acs.curs.pub.ro/',
        isPrivate: false,
      ),
      Website(
        id: '2',
        relevance: null,
        category: WebsiteCategory.learning,
        iconPath: 'icons/websites/ocw.png',
        infoByLocale: {},
        label: 'OCW',
        link: 'https://ocw.cs.pub.ro/',
        isPrivate: false,
      ),
      Website(
        id: '3',
        relevance: null,
        category: WebsiteCategory.administrative,
        iconPath: 'icons/websites/studenti.png',
        infoByLocale: {},
        label: 'studenti',
        link: 'https://studenti.pub.ro/',
        isPrivate: false,
      ),
    ];

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
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).sectionFrequentlyAccessedWebsites,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        GestureDetector(
                          onTap: () => tabController.animateTo(2),
                          child: Row(
                            children: <Widget>[
                              Text(
                                S.of(context).actionShowMore,
                                style: Theme.of(context)
                                    .accentTextTheme
                                    .subtitle2
                                    .copyWith(
                                        color: Theme.of(context).accentColor),
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
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: websites
                          .map((website) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder<ImageProvider<dynamic>>(
                                    future: Provider.of<StorageProvider>(
                                            context,
                                            listen: false)
                                        .imageFromPath(website.iconPath),
                                    builder: (context, snapshot) {
                                      ImageProvider<dynamic> image = AssetImage(
                                          'assets/icons/websites/globe.png');
                                      if (snapshot.hasData) {
                                        image = snapshot.data;
                                      }
                                      return CircleImage(
                                        label: website.label,
                                        onTap: () =>
                                            _launchURL(website.link, context),
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
            ),
          ),
        ],
      ),
    );
  }
}
