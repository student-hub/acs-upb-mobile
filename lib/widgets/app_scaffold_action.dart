import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppScaffoldAction {
  AppScaffoldAction({
    this.icon,
    this.route,
    this.onPressed,
    this.tooltip,
    this.text,
    this.items,
    bool disabled,
  }) : disabled = disabled ?? false;

  // Icon for the action button
  final IconData icon;

  // Route to push when the action button is pressed
  final String route;

  // Action that happens when the button is pressed. This overrides [route].
  final void Function() onPressed;

  // Action button tooltip text
  final String tooltip;

  // Action text. This overrides [icon].
  final String text;

  // Option-action map that should be specified if a popup menu is needed. It
  // overrides [route].
  final Map<String, void Function()> items;

  // Whether the icon color should be disabled.
  final bool disabled;

  Widget toWidget(
      {@required bool enableContent, @required BuildContext context}) {
    final void Function() onPressed =
        !enableContent || (this.onPressed == null && route == null)
            ? null
            : this.onPressed ?? () => Navigator.pushNamed(context, route);

    final icon = disabled
        ? Icon(this.icon ?? Icons.menu_outlined,
            color: Theme.of(context).disabledColor)
        : Icon(this.icon);

    return items != null
        ? PopupMenuButton<String>(
            icon: icon,
            tooltip: tooltip ?? text,
            onSelected: (selected) => items[selected](),
            itemBuilder: (BuildContext context) {
              return items.keys
                  .map((option) => PopupMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList();
            },
          )
        : Tooltip(
            message: tooltip ?? text ?? '',
            child: text != null
                ? ButtonTheme(
                    minWidth: 10,
                    child: TextButton(
                      child: Text(
                        text,
                        style: const TextStyle().apply(
                            color: Theme.of(context).primaryIconTheme.color),
                      ),
                      onPressed: onPressed,
                    ),
                  )
                : IconButton(
                    icon: icon,
                    onPressed: onPressed,
                  ),
          );
  }

  /// Wrap simple action button to enable hover and splash effects
  AspectRatio toMaterialActionButton(
      {@required bool enableContent, @required BuildContext context}) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.none,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Theme.of(context).primaryColor.withOpacity(0.12),
            hoverColor: Theme.of(context).primaryColor.withOpacity(0.04),
          ),
          child: toWidget(enableContent: enableContent, context: context),
        ),
      ),
    );
  }
}
