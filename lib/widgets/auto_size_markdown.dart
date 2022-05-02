import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class AutoSizeMarkdownBody extends MarkdownWidget {
  const AutoSizeMarkdownBody(
      {final Key key,
      final String data,
      final MarkdownStyleSheet styleSheet,
      final SyntaxHighlighter syntaxHighlighter,
      final MarkdownTapLinkCallback onTapLink,
      final String imageDirectory,
      final bool fitContent,
      final md.ExtensionSet extensionSet,
      this.overflow,
      this.maxLines})
      : super(
          key: key,
          data: data,
          styleSheet: styleSheet,
          syntaxHighlighter: syntaxHighlighter,
          onTapLink: onTapLink,
          imageDirectory: imageDirectory,
          fitContent: fitContent,
          extensionSet: extensionSet,
        );

  final TextOverflow overflow;
  final int maxLines;

  @override
  Widget build(final BuildContext context, final List<Widget> children) {
    final richText = _findWidgetOfType<RichText>(children.first);
    if (richText != null) {
      return RichText(
          text: richText.text,
          textAlign: richText.textAlign,
          textDirection: richText.textDirection,
          softWrap: richText.softWrap,
          overflow: overflow,
          textScaleFactor: richText.textScaleFactor,
          maxLines: maxLines,
          locale: richText.locale);
    }

    return children.first;
  }

  T _findWidgetOfType<T>(final Widget widget) {
    if (widget is T) {
      return widget as T;
    }

    if (widget is MultiChildRenderObjectWidget) {
      final MultiChildRenderObjectWidget multiChild = widget;
      for (final child in multiChild.children) {
        return _findWidgetOfType<T>(child);
      }
    } else if (widget is SingleChildRenderObjectWidget) {
      final SingleChildRenderObjectWidget singleChild = widget;
      return _findWidgetOfType<T>(singleChild.child);
    }

    return null;
  }
}
