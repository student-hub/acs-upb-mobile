import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/websites/model/website.dart';
import 'package:acs_upb_mobile/pages/websites/service/website_provider.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/spoiler/view/spoiler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebsitesPage extends StatefulWidget {
  @override
  _WebsitesPageState createState() => _WebsitesPageState();
}

class _WebsitesPageState extends State<WebsitesPage> {
  Widget listCategory(String category, List<Website> websites) {
    if (websites == null || websites.isEmpty) {
      return Container();
    }

    return SafeArea(
      child: Spoiler(
        isOpened: true,
        leadingArrow: true,
        header: Text(
          category,
          style: Theme.of(context).textTheme.headline6,
        ),
        child: Container(
          height: MediaQuery.of(context).size.width / 3,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: websites
                .map((website) => Padding(
                    padding:
                        const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                    child: FutureBuilder<ImageProvider<dynamic>>(
                      future: Storage.getImageFromPath(website.iconPath),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CircleImage(
                            label: website.label,
                            tooltip:
                                website.infoByLocale[Utils.getLocale(context)],
                            image: snapshot.data,
                          );
                        } else {
                          return Container();
                        }
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
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);

    return AppScaffold(
      title: S.of(context).navigationWebsites,
      body: StreamBuilder<List<Website>>(
          stream: websiteProvider.getWebsites(),
          builder: (context, AsyncSnapshot<List<Website>> snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              var websites = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: listWebsitesByCategory(websites),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
