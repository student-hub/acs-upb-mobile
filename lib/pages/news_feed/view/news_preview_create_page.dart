import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';

import '../../../resources/utils.dart';
import '../../../widgets/scaffold.dart';

class NewsPreviewCreatePage extends StatelessWidget {
  const NewsPreviewCreatePage({@required this.title, @required this.body});

  final String title;
  final String body;

  @override
  Widget build(final BuildContext context) {
    final captionStyle = Theme.of(context).textTheme.caption;
    final captionSizeFactor =
        captionStyle.fontSize / Theme.of(context).textTheme.bodyText1.fontSize;
    final captionColor = captionStyle.color;

    return AppScaffold(
      title: const Text('Preview post'),
      needsToBeAuthenticated: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _newsPreviewTitle(context: context, title: title),
                  const SizedBox(height: 5),
                  _newsPreviewContent(
                      content: body,
                      captionColor: captionColor,
                      captionSizeFactor: captionSizeFactor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _newsPreviewTitle({final BuildContext context, final String title}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Theme.of(context).textTheme.bodyText1.fontSize * 1.1),
            ),
          ),
        ],
      );

  Widget _newsPreviewContent(
          {final String content,
          final Color captionColor,
          final double captionSizeFactor}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: MarkdownBody(
                fitContent: false,
                onTapLink: (final text, final link, final title) =>
                    Utils.launchURL(link),
                /*
                  This is a workaround because the strings in Firebase represent
                  newlines as '\n' and Firebase replaces them with '\\n'. We need
                  to replace them back for them to display properly.
                  (See GitHub issue firebase/firebase-js-sdk#2366)
                  */
                data: content.replaceAll('\\n', '\n'),
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
