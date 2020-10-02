import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/pages/faq/service/question_provider.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/auto_size_markdown.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:markdown/markdown.dart' as md;

class HomePage extends StatelessWidget {
  const HomePage({this.tabController, Key key}) : super(key: key);

  final TabController tabController;

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
          ProfileCard(),
          // Favourite websites
          InfoCard<List<Website>>(
            title: S.of(context).sectionFrequentlyAccessedWebsites,
            onShowMore: () => tabController?.animateTo(2),
            future: Provider.of<WebsiteProvider>(context).fetchWebsites(null),
            builder: (websites) => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: websites
                  .take(3)
                  .map((website) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: FutureBuilder<ImageProvider<dynamic>>(
                            future:
                                StorageProvider.imageFromPath(website.iconPath),
                            builder: (context, snapshot) {
                              ImageProvider<dynamic> image = const AssetImage(
                                  'assets/icons/websites/globe.png');
                              if (snapshot.hasData) {
                                image = snapshot.data;
                              }
                              return CircleImage(
                                label: website.label,
                                onTap: () {
                                  Provider.of<WebsiteProvider>(context,
                                          listen: false)
                                      .incrementNumberOfVisits(website);
                                  Utils.launchURL(website.link,
                                      context: context);
                                },
                                image: image,
                                tooltip: website
                                    .infoByLocale[LocaleProvider.localeString],
                              );
                            },
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          // FAQ
          InfoCard<List<Question>>(
            title: S.of(context).sectionFAQ,
            showMoreButtonKey: const ValueKey('show_more_faq'),
            onShowMore: () => Navigator.of(context).pushNamed(Routes.faq),
            future:
                Provider.of<QuestionProvider>(context).fetchQuestions(limit: 2),
            builder: (questions) => Column(
              children: questions
                  .map(
                    (q) => ListTile(
                      title: Text(q.question),
                      subtitle: AutoSizeMarkdownBody(
                        fitContent: false,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        /*
                        This is a workaround because the strings in Firebase represent
                        newlines as '\n' and Firebase replaces them with '\\n'. We need
                        to replace them back for them to display properly.
                        (See GitHub issue firebase/firebase-js-sdk#2366)
                        */
                        data: q.answer.replaceAll('\\n', '\n'),
                        extensionSet: md.ExtensionSet(
                            md.ExtensionSet.gitHubFlavored.blockSyntaxes, [
                          md.EmojiSyntax(),
                          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                        ]),
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    String userName;
    final User user = authProvider.currentUserFromCache;
    String userGroup;
    if (user != null) {
      userName = '${user.firstName} ${user.lastName}';
      userGroup = user.classes?.isNotEmpty ?? false ? user.classes.last : null;
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: CircleAvatar(
                      radius: 40,
                      child: Image(
                          image: AssetImage(
                              'assets/illustrations/undraw_profile_pic.png')),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FittedBox(
                            child: Text(
                              userName ?? S.of(context).stringAnonymous,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .apply(fontWeightDelta: 2),
                            ),
                          ),
                          if (userGroup != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(userGroup,
                                  style: Theme.of(context).textTheme.subtitle1),
                            ),
                          InkWell(
                            onTap: () {
                              Utils.signOut(context);
                            },
                            child: Text(
                                authProvider.isAnonymous
                                    ? S.of(context).actionLogIn
                                    : S.of(context).actionLogOut,
                                style: Theme.of(context)
                                    .accentTextTheme
                                    .subtitle2
                                    .copyWith(fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (user != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Theme.of(context).textTheme.button.color,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<EditProfilePage>(
                              builder: (context) => const EditProfilePage(),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              AccountNotVerifiedWarning(),
            ],
          ),
        ),
      ),
    );
  }
}
