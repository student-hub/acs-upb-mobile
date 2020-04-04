import 'dart:math';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PortalPage extends StatefulWidget {
  @override
  _PortalPageState createState() => _PortalPageState();
}

class _PortalPageState extends State<PortalPage> {
  Future<Filter> filterFuture;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppToast.show(S.of(context).errorCouldNotLaunchURL(url));
    }
  }

  Widget spoiler({String title, Widget content}) => ExpandableNotifier(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ExpandableTheme(
              data: ExpandableThemeData(
                  useInkWell: false,
                  crossFadePoint: 0.5,
                  hasIcon: true,
                  iconPlacement: ExpandablePanelIconPlacement.left,
                  iconColor: Theme.of(context).textTheme.headline6.color,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  iconPadding: EdgeInsets.only()),
              child: ExpandablePanel(
                controller: ExpandableController(initialExpanded: true),
                header:
                    Text(title, style: Theme.of(context).textTheme.headline6),
                collapsed: SizedBox(height: 12.0),
                expanded: content,
              ),
            ),
          ],
        ),
      );

  Widget listCategory(String category, List<Website> websites) {
    if (websites == null || websites.isEmpty) {
      return Container();
    }
    StorageProvider storageProvider = Provider.of<StorageProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: spoiler(
        title: category,
        content: Container(
          height: min(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height) /
                  5 + // circle
              8 + // padding
              ScreenUtil().setHeight(80), // text
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: websites
                .map((website) => Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: FutureBuilder<ImageProvider<dynamic>>(
                      future:
                          storageProvider.getImageFromPath(website.iconPath),
                      builder: (context, snapshot) {
                        var image;
                        if (snapshot.hasData) {
                          image = snapshot.data;
                        } else {
                          image = AssetImage('assets/' + website.iconPath) ??
                              AssetImage('assets/images/white.png');
                        }
                        return CircleImage(
                          label: website.label,
                          tooltip:
                              website.infoByLocale[Utils.getLocaleString()],
                          image: image,
                          onTap: () => _launchURL(website.link),
                        );
                      },
                    )))
                .toList(),
          ),
        ),
      ),
    );
  }

  List<Widget> listWebsitesByCategory(List<Website> websites) {
    if (websites == null || websites.isEmpty) {
      return <Widget>[];
    }

    Map<WebsiteCategory, List<Website>> map = Map();
    websites.forEach((website) {
      var category = website.category;
      map.putIfAbsent(category, () => List<Website>());
      map[category].add(website);
    });

    return [
      WebsiteCategory.learning,
      WebsiteCategory.administrative,
      WebsiteCategory.association,
      WebsiteCategory.resource,
      WebsiteCategory.other
    ]
        .map((category) =>
            listCategory(category.toLocalizedString(context), map[category]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);

    if (filterFuture == null) {
      filterFuture =
          Provider.of<FilterProvider>(context).getRelevanceFilter(context);
    }

    List<Website> websites = [];

    CircularProgressIndicator progressIndicator = CircularProgressIndicator();

    return AppScaffold(
      title: S.of(context).navigationPortal,
      enableMenu: true,
      menuIcon: CustomIcons.filter,
      menuRoute: Routes.filter,
      menuName: S.of(context).navigationFilter,
      body: FutureBuilder(
        future: filterFuture,
        builder: (BuildContext context, AsyncSnapshot<Filter> filterSnap) {
          if (filterSnap.hasData) {
            return FutureBuilder<List<Website>>(
                future: websiteProvider.getWebsites(filterSnap.data),
                builder: (context, AsyncSnapshot<List<Website>> websiteSnap) {
                  if (websiteSnap.hasData) {
                    websites = websiteSnap.data;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Column(
                          children: listWebsitesByCategory(websites),
                        ),
                      ),
                    );
                  } else if (websiteSnap.hasError) {
                    print(filterSnap.error);
                    // TODO: Show error toast
                    return Container();
                  } else {
                    return Center(child: progressIndicator);
                  }
                });
          } else if (filterSnap.hasError) {
            print(filterSnap.error);
            // TODO: Show error toast
            return Container();
          } else {
            return Center(child: progressIndicator);
          }
        },
      ),
    );
  }
}
