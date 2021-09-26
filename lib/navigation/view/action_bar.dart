import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  const ActionBar(this.actionButtons);

  final List<Widget> actionButtons;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).bottomAppBarColor.withOpacity(0),
      child: Row(
        textDirection: TextDirection.rtl,
        children: actionButtons,
      ),
    );
  }
}
