import 'package:flutter/material.dart';

class EmojiFormField extends FormField<Map<int, bool>> {
  EmojiFormField({
    @required final Map<int, bool> answerValues,
    @required final String question,
    final FormFieldSetter<Map<int, bool>> onSaved,
    final Key key,
  }) : super(
          key: key,
          onSaved: onSaved,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: answerValues,
          builder: (final state) {
            final context = state.context;
            final List<Icon> emojis = [
              const Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
                size: 29,
              ),
              const Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.orange,
                size: 29,
              ),
              const Icon(
                Icons.sentiment_neutral,
                color: Colors.amber,
                size: 29,
              ),
              const Icon(
                Icons.sentiment_satisfied,
                color: Colors.lightGreen,
                size: 29,
              ),
              const Icon(
                Icons.sentiment_very_satisfied,
                color: Colors.green,
                size: 29,
              )
            ];
            final List<SelectableIconController> emojiControllers =
                emojis.map((final _) => SelectableIconController()).toList();

            final emojiSelectables = emojiControllers
                .asMap()
                .map(
                  (final i, final controller) => MapEntry(
                    i,
                    SelectableIcon(
                      icon: emojis[i],
                      controller: controller,
                      onSelected: (final selected) {
                        if (selected) {
                          for (final c in emojiControllers) {
                            if (c != controller) {
                              c.deselect();
                              state.value[i] = selected;
                              state.value[emojiControllers.indexOf(c)] =
                                  !selected;
                            }
                          }
                          controller.select();
                          state.value[i] = selected;
                          state.didChange(state.value);
                        } else {
                          controller.deselect();
                          state.value[i] = selected;
                          state.didChange(state.value);
                        }
                      },
                    ),
                  ),
                )
                .values
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Text(
                  '$question',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: emojiSelectables,
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Theme.of(context).errorColor),
                    ),
                  ),
              ],
            );
          },
        );
}

class SelectableIconController {
  _SelectableIconState _state;

  bool get isSelected => _state?.isSelected;

  void select() {
    if (_state == null) return;
    if (!isSelected) {
      _state.isSelected = true;
      _state.animationController.forward();
    }
  }

  void deselect() {
    if (_state == null) return;
    if (isSelected) {
      _state.isSelected = false;
      _state.animationController.reverse();
    }
  }
}

class SelectableIcon extends StatefulWidget {
  SelectableIcon({
    this.onSelected,
    this.icon,
    final SelectableIconController controller,
  }) : controller = controller ?? SelectableIconController();

  final void Function(bool) onSelected;
  final Icon icon;
  final SelectableIconController controller;

  @override
  State<SelectableIcon> createState() => _SelectableIconState();
}

class _SelectableIconState extends State<SelectableIcon>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = false;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 1, end: 1.5).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    widget.controller._state = this;

    return GestureDetector(
      onTap: () {
        setState(
          () {
            if (isSelected) {
              widget.controller.deselect();
            } else {
              widget.controller.select();
            }
            widget.onSelected(isSelected);
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.none, width: 1),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: AnimatedBuilder(
          animation: animation,
          child: widget.icon,
          builder: (final BuildContext context, final Widget child) {
            return Transform.scale(
              scale: animation.value,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
