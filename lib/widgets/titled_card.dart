import 'package:flutter/material.dart';

class TitledCard extends StatelessWidget {
  TitledCard({
    @required this.title,
    @required this.body,
    this.titleStyle,
    this.color,
    Color dividerColor,
    Key key,
  })  : _dividerColor = dividerColor ?? color?.withOpacity(0.8),
        super(key: key);
  final String title;
  final Widget body;
  final TextStyle titleStyle;
  final Color color;
  final Color _dividerColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Card(
        shape: color != null
            ? Theme.of(context)
                .cardTheme
                .copyWith(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: color),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
                .shape
            : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: titleStyle ?? Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              Divider(
                color: _dividerColor ?? Theme.of(context).backgroundColor,
              ),
              Center(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
