import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/pages/portal/view/website_view.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PortalPage extends StatefulWidget {
  @override
  _PortalPageState createState() => _PortalPageState();
}

class _PortalPageState extends State<PortalPage> {
  Future<Filter> filterFuture;

  // Only show user-added websites
  bool userOnly = false;

  bool editingEnabled = false;

  User user;

  _fetchUser() async {
    AuthProvider authProvider = Provider.of(context, listen: false);
    user = await authProvider.currentUser;
    setState(() {});
  }

  initState() {
    super.initState();
    _fetchUser();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppToast.show(S.of(context).errorCouldNotLaunchURL(url));
    }
  }

  Widget spoiler({String title, Widget content, bool initialExpanded = true}) =>
      ExpandableNotifier(
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
                controller:
                    ExpandableController(initialExpanded: initialExpanded),
                header:
                    Text(title, style: Theme.of(context).textTheme.headline6),
                collapsed: SizedBox(height: 12.0),
                expanded: content,
              ),
            ),
          ],
        ),
      );

  Widget addWebsiteButton({bool trailing = false}) => Tooltip(
        message: S.of(context).actionAddWebsite,
        child: GestureDetector(
          onTap: () {
            AuthProvider authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            if (authProvider.isAuthenticatedFromCache &&
                !authProvider.isAnonymous) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider<FilterProvider>(
                    create: (_) => FilterProvider(), child: WebsiteView()),
              ));
            } else {
              AppToast.show(S.of(context).warningAuthenticationNeeded);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: CircleImage(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).unselectedWidgetColor,
              ),
              label: trailing ? "" : null,
              circleScaleFactor: 0.6,
              // Only align when there is no other website in the category
              alignWhenScaling: !trailing,
            ),
          ),
        ),
      );

  Widget listCategory(String category, List<Website> websites) {
    StorageProvider storageProvider = Provider.of<StorageProvider>(context);
    bool hasContent = websites != null && websites.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: spoiler(
        title: category,
        initialExpanded: hasContent,
        content: !hasContent
            ? Container(
                height: 80.0 + // circle
                    8.0, // padding
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      addWebsiteButton(),
                    ],
                  ),
                ),
              )
            : Container(
                height: 80.0 + // circle
                    8.0 + // padding
                    40.0, // text
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: websites
                          .map<Widget>(
                            (website) => Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              child: FutureBuilder<ImageProvider<dynamic>>(
                                future: storageProvider
                                    .imageFromPath(website.iconPath),
                                builder: (context, snapshot) {
                                  var image;
                                  if (snapshot.hasData) {
                                    image = snapshot.data;
                                  } else {
                                    image = AssetImage(
                                            'assets/' + website.iconPath) ??
                                        AssetImage('assets/images/white.png');
                                  }

                                  bool canEdit = editingEnabled &&
                                      (website.isPrivate ||
                                          (user.canEditPublicWebsite ?? false));
                                  return CircleImage(
                                    label: website.label,
                                    tooltip: website.infoByLocale[
                                        LocaleProvider.localeString],
                                    image: image,
                                    enableOverlay: canEdit,
                                    onTap: () => canEdit
                                        ? Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (_) => WebsiteView(
                                                      website: website,
                                                      updateExisting: true,
                                                    )))
                                        : _launchURL(website.link),
                                  );
                                },
                              ),
                            ),
                          )
                          .toList() +
                      <Widget>[addWebsiteButton(trailing: true)],
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
    FilterProvider filterProvider = Provider.of<FilterProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    if (filterFuture == null) {
      filterFuture = filterProvider.fetchFilter(context);
    }

    List<Website> websites = [];

    CircularProgressIndicator progressIndicator = CircularProgressIndicator();

    return AppScaffold(
      title: S.of(context).navigationPortal,
      actions: [
        AppScaffoldAction(
          icon: editingEnabled ? CustomIcons.edit_slash : Icons.edit,
          tooltip: editingEnabled
              ? S.of(context).actionDisableEditing
              : S.of(context).actionEnableEditing,
          onPressed: () {
            AuthProvider authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            if (authProvider.isAuthenticatedFromCache &&
                !authProvider.isAnonymous) {
              // Show message if there is nothing the user can edit
              if (!editingEnabled) {
                websiteProvider.hasEditableWebsites(user).then((canEdit) {
                  if (!canEdit)
                    AppToast.show(S.of(context).warningNothingToEdit +
                        ' ' +
                        S.of(context).messageAddCustomWebsite);
                });
              }

              setState(() => editingEnabled = !editingEnabled);
            } else {
              AppToast.show(S.of(context).warningAuthenticationNeeded);
            }
          },
        ),
        AppScaffoldAction(
          icon: CustomIcons.filter,
          tooltip: S.of(context).navigationFilter,
          items: {
            S.of(context).filterMenuRelevance: () {
              filterFuture = null; // reset filter cache
              userOnly = false;
              Navigator.pushNamed(context, Routes.filter);
            },
            S.of(context).filterMenuShowMine: () {
              filterFuture = null; // reset filter cache
              setState(() => userOnly = true);
              filterProvider.enableFilter();
            },
            S.of(context).filterMenuShowAll: () {
              if (!filterProvider.filterEnabled) {
                AppToast.show(S.of(context).warningFilterAlreadyDisabled);
              } else {
                filterFuture = null; // reset filter cache
                userOnly = false;
                filterProvider.disableFilter();
              }
            },
          },
        ),
      ],
      body: FutureBuilder(
        future: filterFuture,
        builder: (BuildContext context, AsyncSnapshot<Filter> filterSnap) {
          if (filterSnap.connectionState == ConnectionState.done) {
            return FutureBuilder<List<Website>>(
                future: websiteProvider.fetchWebsites(
                  filterProvider.filterEnabled ? filterSnap.data : null,
                  userOnly: userOnly,
                  uid: authProvider.uid,
                ),
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
