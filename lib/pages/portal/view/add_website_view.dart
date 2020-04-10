import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddWebsiteView extends StatefulWidget {
  static const String routeName = '/add_website';

  @override
  _AddWebsiteViewState createState() => _AddWebsiteViewState();
}

class _AddWebsiteViewState extends State<AddWebsiteView> {
  final _formKey = GlobalKey<FormState>();
  final _labelKey = GlobalKey<FormFieldState>();
  final _linkKey = GlobalKey<FormFieldState>();

  WebsiteCategory _selectedCategory = WebsiteCategory.learning;
  TextEditingController _labelController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  // The "Only me" and "Anyone" relevance options are mutually exclusive
  SelectableController _onlyMeController = SelectableController();
  SelectableController _anyoneController = SelectableController();

  List<Widget> relevanceList() => [
        Selectable(
          label: S.of(context).relevanceOnlyMe,
          initiallySelected: true,
          onSelected: (selected) => setState(() => selected
              ? _anyoneController.deselect()
              : _anyoneController.select()),
          controller: _onlyMeController,
        ),
        SizedBox(width: 4),
        Selectable(
          label: S.of(context).relevanceAnyone,
          initiallySelected: false,
          onSelected: (selected) => setState(() => selected
              ? _onlyMeController.deselect()
              : _onlyMeController.select()),
          controller: _anyoneController,
        ),
      ];

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
            Website(
              label: _labelController.text,
              link: _linkController.text,
              category: _selectedCategory,
            ),
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
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: ScreenUtil().setHeight(800),
                child: Image.asset(
                    'assets/illustrations/undraw_the_world_is_mine.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      key: _labelKey,
                      controller: _labelController,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelName,
                        prefixIcon: Icon(Icons.label),
                      ),
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
                      key: _linkKey,
                      controller: _linkController,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelLink,
                        prefixIcon: Icon(Icons.public),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return S.of(context).warningInvalidURL;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 28.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Icon(CustomIcons.filter, color: Theme.of(context).hintColor),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.of(context).labelRelevance,
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 4.0),
                        Container(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: relevanceList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
