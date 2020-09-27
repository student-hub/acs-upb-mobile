import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/pages/faq/service/question_provider.dart';
import 'package:acs_upb_mobile/pages/faq/view/faq_page.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
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
          ProfileCard(),
          FavouriteWebsitesCard(
            onSeeMore: () => tabController?.animateTo(2),
          ),
          FaqCard(
            onSeeMore: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => FaqPage(),
              ),
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
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return FutureBuilder(
      future: authProvider.currentUser,
      builder: (BuildContext context, AsyncSnapshot<User> snap) {
        if (snap.connectionState == ConnectionState.done) {
          String userName;
          String userGroup;
          User user = snap.data;
          if (user != null) {
            userName = user.firstName + ' ' + user.lastName;
            userGroup = user.classes != null ? user.classes.last : null;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CircleAvatar(
                            radius: 40,
                            child: Image(
                                image: AssetImage(
                                    'assets/illustrations/undraw_profile_pic.png')),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
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
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(userGroup,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
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
                                          .copyWith(
                                              fontWeight: FontWeight.w500)),
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
                                icon: Icon(Icons.edit),
                                color: Theme.of(context).textTheme.button.color,
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(),
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
        return Container();
      },
    );
  }
}

class FavouriteWebsitesCard extends StatelessWidget {
  final Function onSeeMore;

  FavouriteWebsitesCard({this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    var websitesFuture =
        Provider.of<WebsiteProvider>(context).fetchWebsites(null);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: FutureBuilder(
          future: websitesFuture,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Website> websites = snapshot.data;
              websites =
                  websites.where((w) => w.numberOfVisits > 0).take(3).toList();
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
                            onTap: onSeeMore,
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
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      if (websites.isEmpty)
                        noneYet(context)
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: websites
                              .take(3)
                              .map((website) => Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          FutureBuilder<ImageProvider<dynamic>>(
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
          }),
    );
  }

  Widget noneYet(BuildContext context) => Container(
        height: 100,
        child: Center(
          child: Text(
            S.of(context).warningNoneYet,
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
        ),
      );
}

class FaqCard extends StatelessWidget {
  final Function onSeeMore;

  FaqCard({this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    var questionsFuture = Provider.of<QuestionProvider>(context).fetchQuestions(context: null, limit: 2);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: FutureBuilder(
          future: questionsFuture,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Question> questions = snapshot.data;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).sectionFAQ,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: onSeeMore,
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
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      if (questions.isEmpty)
                        noneYet(context)
                      else
                        Column(
                          children: questions
                              .map(
                                (q) => ListTile(
                                  title: Text(q.question),
                                  subtitle: AutoSizeText(
                                    q.answer,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              )
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
          }),
    );
  }

  Widget noneYet(BuildContext context) => Container(
        height: 100,
        child: Center(
          child: Text(
            S.of(context).warningNoneYet,
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
        ),
      );
}
