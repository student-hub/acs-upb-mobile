import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/websites/website.dart';
import 'package:acs_upb_mobile/pages/websites/website_provider.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
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

  @override
  Widget build(BuildContext context) {
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);

    return AppScaffold(
        title: S.of(context).navigationWebsites,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<List<Website>>(
              stream: websiteProvider.getWebsites(),
              builder: (context, AsyncSnapshot<List<Website>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  var websites = snapshot.data;

                  return ListView.builder(
                    itemCount: websites != null ? websites.length : 0,
                    itemBuilder: (_, int index) {
                      final Website website = websites[index];
                      if (website == null) return Container();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<ImageProvider<dynamic>>(
                          future: Storage.getImageFromPath(website.iconPath),
                          builder: (context, snapshot) {
                            ImageProvider image;
                            if (snapshot.hasData) {
                              image = snapshot.data;
                            } else {
                              image = AssetImage('assets/icons/globe.png');
                            }
                            return CircleImage(
                              label: website.label,
                              image: image,
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              }),
        ));
  }
}
