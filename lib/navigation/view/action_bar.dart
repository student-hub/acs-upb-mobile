import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  const ActionBar(this.actionButtons);

  final List<Widget> actionButtons;


  @override
  Widget build(BuildContext context) {

    return Positioned(
      top: 0,
      right: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 100),
        child: Row(
          children: actionButtons,
        ),
      ),
    );
  }
}