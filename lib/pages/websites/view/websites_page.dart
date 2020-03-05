import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/websites/model/website.dart';
import 'package:acs_upb_mobile/pages/websites/service/website_provider.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
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
  List<Website> websites;

  @override
  void initState() {
    super.initState();
    websites = [];
  }

  List<Widget> listWebsitesByCategory(List<Website> websites) {
    Map<String, List<Website>> map = Map();
    websites.forEach((website) {
      String category = website.category;
      map.putIfAbsent(category, () => List<Website>());
      map[category].add(website);
    });

    var children = List<Widget>();
    map.forEach((String category, websites) {
      children.add(SafeArea(
          child: Spoiler(
        isOpened: true,
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
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<ImageProvider<dynamic>>(
                      future: Storage.getImageFromPath(website.iconPath),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CircleImage(
                            label: website.label,
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
      )));
    });
    return children;
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
              return Column(
                children: listWebsitesByCategory(websites),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
