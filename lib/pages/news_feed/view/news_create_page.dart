import 'package:flutter/material.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../service/news_provider.dart';

class NewsCreatePage extends StatefulWidget {
  const NewsCreatePage({final Key key}) : super(key: key);

  static const String routeName = '/news_create';

  @override
  _NewsCreatePageState createState() => _NewsCreatePageState();
}

class _NewsCreatePageState extends State<NewsCreatePage> {
  final postTitleController = TextEditingController();
  final postBodyController = TextEditingController();

  final formKey = GlobalKey<FormState>();

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
                  const Text(
                    'Choose an appropriate title for your post. This title will be displayed in the news feed. It should be not very long, but descriptive (max. 50 chars).',
                    textAlign: TextAlign.justify,
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
                  const SizedBox(height: 10),
                  const Text(
                    'Enter the content of your post. This text will be displayed when clicked on by the user. You can use Markdown syntax to better format your post.',
                    textAlign: TextAlign.justify,
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
