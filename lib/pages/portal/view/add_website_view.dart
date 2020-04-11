import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

class AddWebsiteView extends StatefulWidget {
  static const String routeName = '/add_website';

  @override
  _AddWebsiteViewState createState() => _AddWebsiteViewState();
}

class _AddWebsiteViewState extends State<AddWebsiteView> {
  final _formKey = GlobalKey<FormState>();

  WebsiteCategory _selectedCategory = WebsiteCategory.learning;
  TextEditingController _labelController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _descriptionRoController = TextEditingController();
  TextEditingController _descriptionEnController = TextEditingController();

  // The "Only me" and "Anyone" relevance options are mutually exclusive
  SelectableController _onlyMeController = SelectableController();
  SelectableController _anyoneController = SelectableController();

  User _user;

  _fetchUser() async {
    AuthProvider authProvider = Provider.of(context, listen: false);
    _user = await authProvider.currentUser;
    setState(() {});
  }

  @override
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

  // Icon color from InputDecoration
  Color get _iconColor {
    ThemeData themeData = Theme.of(context);

    switch (themeData.brightness) {
      case Brightness.dark:
        return Colors.white70;
      case Brightness.light:
        return Colors.black45;
      default:
        return themeData.iconTheme.color;
    }
  }

  Website buildWebsite() => Website(
          label: _labelController.text,
          link: _linkController.text,
          category: _selectedCategory,
          infoByLocale: {
            'ro': _descriptionRoController.text,
            'en': _descriptionEnController.text
          });

  Widget preview() {
    Website website = buildWebsite();

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 8.0, top: 8.0),
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.remove_red_eye, color: _iconColor),
                  SizedBox(width: 12.0),
                  Text(
                    S.of(context).labelPreview + ':',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FutureBuilder<ImageProvider<dynamic>>(
                          future: Provider.of<StorageProvider>(context,
                                  listen: false)
                              .imageFromPath('icons/websites/globe.png'),
                          builder: (context, snapshot) {
                            ImageProvider<dynamic> image =
                                AssetImage('icons/websites/globe.png');
                            if (snapshot.hasData) {
                              image = snapshot.data;
                            }
                            return CircleImage(
                              label: website.label,
                              onTap: () => _launchURL(website.link),
                              image: image,
                              tooltip:
                                  website.infoByLocale[LocaleProvider.localeString],
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                          child: CircleImage(
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                            label: "",
                            circleScaleFactor: 0.6,
                            // Only align when there is no other website in the category
                            alignWhenScaling: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: AutoSizeText(
                S.of(context).messageWebsitePreview,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget relevanceField() => Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 12.0),
        child: Row(
          children: <Widget>[
            Icon(CustomIcons.filter, color: _iconColor),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).labelRelevance,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .apply(color: Theme.of(context).hintColor),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Selectable(
                          label: S.of(context).relevanceOnlyMe,
                          initiallySelected: true,
                          onSelected: (selected) => setState(() {
                            if (_user?.canAddPublicWebsite ?? false) {
                              selected
                                  ? _anyoneController.deselect()
                                  : _anyoneController.select();
                            } else {
                              _onlyMeController.select();
                            }
                          }),
                          controller: _onlyMeController,
                        ),
                        SizedBox(width: 8.0),
                        Selectable(
                          label: S.of(context).relevanceAnyone,
                          initiallySelected: false,
                          onSelected: (selected) => setState(() {
                            if (_user?.canAddPublicWebsite ?? false) {
                              selected
                                  ? _onlyMeController.deselect()
                                  : _onlyMeController.select();
                            } else {
                              AppToast.show(S
                                  .of(context)
                                  .warningNoPermissionToAddPublicWebsite);
                            }
                          }),
                          controller: _anyoneController,
                          disabled: !(_user?.canAddPublicWebsite ?? false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).actionAddWebsite,
      enableMenu: true,
      menuText: S.of(context).buttonSave,
      menuAction: () async {
        if (_formKey.currentState.validate()) {
          bool res = await Provider.of<WebsiteProvider>(context, listen: false)
              .addWebsite(
            buildWebsite(),
            userOnly: _onlyMeController.isSelected,
            context: context,
          );
          if (res) {
            Navigator.of(context).pop();
          }
        }
      },
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            preview(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _labelController,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelName,
                        hintText: S.of(context).hintWebsiteLabel,
                        prefixIcon: Icon(Icons.label),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    DropdownButtonFormField<WebsiteCategory>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelCategory,
                        prefixIcon: Icon(Icons.category),
                      ),
                      value: _selectedCategory,
                      items: WebsiteCategory.values
                          .map(
                            (category) => DropdownMenuItem<WebsiteCategory>(
                              value: category,
                              child: Text(category.toLocalizedString(context)),
                            ),
                          )
                          .toList(),
                      onChanged: (selection) =>
                          setState(() => _selectedCategory = selection),
                    ),
                    TextFormField(
                      controller: _linkController,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelLink + ' *',
                        hintText: S.of(context).hintWebsiteLink,
                        prefixIcon: Icon(Icons.public),
                      ),
                      validator: (value) {
                        if (!isURL(value, requireProtocol: true)) {
                          return S.of(context).warningInvalidURL;
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    relevanceField(),
                    TextFormField(
                      controller: _descriptionRoController,
                      decoration: InputDecoration(
                          labelText: S.of(context).labelDescription +
                              ' (' +
                              S
                                  .of(context)
                                  .settingsItemLanguageRomanian
                                  .toLowerCase() +
                              ')',
                          hintText: 'Cel mai popular motor de căutare.',
                          prefixIcon: Icon(Icons.info)),
                      onChanged: (_) => setState(() {}),
                    ),
                    TextFormField(
                      controller: _descriptionEnController,
                      decoration: InputDecoration(
                          labelText: S.of(context).labelDescription +
                              ' (' +
                              S
                                  .of(context)
                                  .settingsItemLanguageEnglish
                                  .toLowerCase() +
                              ')',
                          hintText: 'The most popular search engine.',
                          prefixIcon: Icon(Icons.info)),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
