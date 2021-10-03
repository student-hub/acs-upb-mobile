import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../resources/theme.dart';

class InfoCard<T> extends StatelessWidget {
  const InfoCard(
      {@required this.future,
      @required this.builder,
      this.onShowMore,
      this.title,
      this.showMoreButtonKey,
      this.padding});

  final Function onShowMore;
  final Future<T> future;
  final Widget Function(T) builder;
  final String title;
  final ValueKey<String> showMoreButtonKey;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null && title.isNotEmpty)
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 18),
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                      ),
                    ),
                  if (onShowMore != null)
                    GestureDetector(
                      onTap: onShowMore,
                      key: showMoreButtonKey ?? const ValueKey('show_more'),
                      child: Row(
                        children: <Widget>[
                          Text(
                            S.current.actionShowMore,
                            style: Theme.of(context)
                                .coloredTextTheme
                                .subtitle2
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Theme.of(context).primaryColor,
                            size:
                                Theme.of(context).textTheme.subtitle2.fontSize,
                          )
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        if ((snapshot.data is Map ||
                                snapshot.data is Iterable) &&
                            snapshot.data.isEmpty) {
                          return noneYet(context);
                        }

                        return builder(snapshot.data);
                      } else {
                        return noneYet(context);
                      }
                    }
                    return const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget noneYet(BuildContext context) => SizedBox(
        height: 100,
        child: Center(
          child: Text(
            S.current.warningNoneYet,
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
        ),
      );
}
