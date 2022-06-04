import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../../filter/view/relevance_picker.dart';
import '../service/news_provider.dart';
import 'news_preview_create_page.dart';

class NewsCreatePage extends StatefulWidget {
  const NewsCreatePage({final Key key}) : super(key: key);

  static const String routeName = '/news_create';

  @override
  _NewsCreatePageState createState() => _NewsCreatePageState();
}

class _NewsCreatePageState extends State<NewsCreatePage> {
  static const String defaultRole = 'student';
  static const String organizationCategory = 'organizations';
  static const String studentCategory = 'students';

  final postTitleController = TextEditingController();
  final postBodyController = TextEditingController();
  final relevanceController = RelevanceController();
  String roleDropdownValue = defaultRole;

  final List<String> userRoles = [defaultRole];

  final formKey = GlobalKey<FormState>();

  void _dropdownChanged(final String value) {
    setState(() {
      roleDropdownValue = value;
    });
  }

  String _computeCategoryForRole(final String categoryRole) {
    if (categoryRole.compareTo(defaultRole) == 0) {
      return studentCategory;
    }

    final roleCategory = categoryRole.split('-')[0];
    if (roleCategory.compareTo(organizationCategory) == 0) {
      return organizationCategory;
    }

    return studentCategory;
  }

  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final roles = authProvider.currentUserFromCache.userRoles;
    userRoles.addAll(roles);
  }

  @override
  Widget build(final BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    return AppScaffold(
      title: const Text('Compose post'),
      needsToBeAuthenticated: true,
      actions: [
        AppScaffoldAction(
          text: S.current.buttonSave,
          onPressed: () async {
            final Map<String, dynamic> info = {
              'title': postTitleController.text,
              'body': postBodyController.text,
              'relevance': relevanceController.customRelevance ??
                  [], //relevance is either specific, or by default for anyone
              'categoryRole': roleDropdownValue,
              'category': _computeCategoryForRole(roleDropdownValue),
            };

            if (formKey.currentState.validate()) {
              if (await newsProvider.savePost(info)) {
                AppToast.show('Post saved');
                if (!mounted) return;
                Navigator.pop(context);
              }
            }
          },
        )
      ],
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Image.asset(
                          'assets/illustrations/undraw_add_notes.png'),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Configure your new post:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Choose an appropriate title for your post. This title will be displayed in the news feed. It should be not very long, but descriptive (max. 50 chars).',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.caption.apply(
                        color: Theme.of(context).textTheme.headline5.color),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter title for the post...',
                      labelText: 'Title',
                    ),
                    controller: postTitleController,
                    validator: (final value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Enter the content of your post. This text will be displayed when clicked on by the user. You can use Markdown syntax to better format your post.',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.caption.apply(
                        color: Theme.of(context).textTheme.headline5.color),
                  ),
                  TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Enter text content...',
                      labelText: 'Body',
                    ),
                    controller: postBodyController,
                    validator: (final value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter some content';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Select your role that will be displayed in the author section. Depending on the role, your post will be grouped within a source category (organizations or students).',
                          style: Theme.of(context).textTheme.caption.apply(
                              color:
                                  Theme.of(context).textTheme.headline5.color),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: roleDropdownValue,
                    iconSize: 24,
                    iconEnabledColor: Theme.of(context).hintColor,
                    elevation: 16,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                    ),
                    underline: Container(
                      height: 0.7,
                      color: Theme.of(context).hintColor,
                    ),
                    onChanged: userRoles != null && userRoles.length > 1
                        ? _dropdownChanged
                        : null,
                    isExpanded: true,
                    items: userRoles
                        .map<DropdownMenuItem<String>>((final String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Choose the most restrictive group that can see your post. You can select as many groups as you want (e.g. 313CA, 314CB, etc.). By selecting \'Anyone\', your post will be visible to all users.',
                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.caption.apply(
                              color:
                                  Theme.of(context).textTheme.headline5.color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  RelevanceFormField(
                    canBePrivate: false,
                    canBeForEveryone: true,
                    controller: relevanceController,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Preview post',
                          style: Theme.of(context)
                              .accentTextTheme
                              .subtitle2
                              .copyWith(color: Theme.of(context).accentColor),
                        ),
                      ],
                    ),
                    onTap: () {
                      final title = postTitleController.text;
                      final body = postBodyController.text;

                      if (title?.isEmpty ?? true) {
                        AppToast.show('Please enter a title');
                        return;
                      }

                      if (body?.isEmpty ?? true) {
                        AppToast.show('Please enter some content');
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute<Map<dynamic, dynamic>>(
                          builder: (final context) => NewsPreviewCreatePage(
                            title: postTitleController.text,
                            body: postBodyController.text,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
