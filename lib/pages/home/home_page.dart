import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/home/faq_card.dart';
import 'package:acs_upb_mobile/pages/home/favourite_websites_card.dart';
import 'package:acs_upb_mobile/pages/home/news_feed_card.dart';
import 'package:acs_upb_mobile/pages/home/profile_card.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.tabController, Key key}) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) async => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AppScaffold(
                actions: [AppScaffoldAction(text: 'Salvare')],
                title: const Text('Surse de informații'),
                body: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          'Aplicația ACS UPB Mobile își propune să fie un hub de informații '
                          'despre facultate, așadar culege date din diverse surse (oficiale '
                          'sau neoficiale).'),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Selectează sursele de informații pe care dorești să le folosești:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      value: true,
                      onChanged: (_) {},
                      title: const Text('Site-uri oficiale'),
                      subtitle: const Text(
                          'acs.pub.ro, upb.ro, curs.upb.ro, studenti.pub.ro'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      value: true,
                      onChanged: (_) {},
                      title: const Text('Organizații studențești*'),
                      subtitle: const Text('LSAC, BEST, MLSA'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      value: true,
                      onChanged: (_) {},
                      title: const Text('Studenți reprezentanți*'),
                      subtitle: const Text(
                          'șefi de grupă, serie și studenții consilieri'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '* Facultatea de Automatică și Calculatoare nu își asumă răspunderea '
                        'pentru informațiile provenite din surse neoficiale.',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: Image.asset(
                              'assets/illustrations/undraw_selected_options.png')),
                    ),
                  ],
                ),
              ),
            )));

    return AppScaffold(
      title: Text(S.of(context).navigationHome),
      actions: [
        AppScaffoldAction(
          icon: Icons.settings,
          tooltip: S.of(context).navigationSettings,
          route: Routes.settings,
        )
      ],
      body: ListView(
        children: [
          ProfileCard(),
          FavouriteWebsitesCard(onShowMore: () => tabController?.animateTo(2)),
          NewsFeedCard(),
          FaqCard(),
        ],
      ),
    );
  }
}
