import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class InfoCard<T> extends StatelessWidget {
  const InfoCard(
      {@required this.future,
      @required this.builder,
      this.onShowMore,
      this.title,
      this.valueKey});

  final Function onShowMore;
  final Future<T> future;
  final Widget Function(T) builder;
  final String title;
  final String valueKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null && title.isNotEmpty)
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 18),
                    ),
                  if (onShowMore != null)
                    GestureDetector(
                      onTap: onShowMore,
                      key: ValueKey(valueKey ?? 'show_more'),
                      child: Row(
                        children: <Widget>[
                          Text(
                            S.of(context).actionShowMore,
                            style: Theme.of(context)
                                .accentTextTheme
                                .subtitle2
                                .copyWith(color: Theme.of(context).accentColor),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).accentColor,
                            size:
                                Theme.of(context).textTheme.subtitle2.fontSize,
                          )
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return builder(snapshot.data);
                      } else {
                        return noneYet(context);
                      }
                    }
                    return Container(
                      height: 100,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }),
            ],
          ),
        ),
      ),
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
