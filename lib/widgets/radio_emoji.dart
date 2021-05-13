import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/material.dart';

class EmojiFormField extends FormField<Map<int, bool>> {
  EmojiFormField({
    @required Map<int, bool> answerValues,
    @required String question,
    FormFieldSetter<Map<int, bool>> onSaved,
    String Function(Map<int, bool>) validator,
    Key key,
  }) : super(
          key: key,
          validator: validator,
          onSaved: onSaved,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: answerValues,
          builder: (state) {
            final context = state.context;
            final List<Icon> emojis = [
              const Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
                size: 29,
              ),
              const Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.redAccent,
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
            final List<SelectableController> emojiControllers =
                emojis.map((_) => SelectableController()).toList();

            final emojiSelectables = emojiControllers
                .asMap()
                .map(
                  (i, controller) => MapEntry(
                    i,
                    SelectableIcon(
                      icon: emojis[i],
                      controller: controller,
                      onSelected: (selected) {
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
                Container(
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

class SelectableIcon extends Selectable {
  const SelectableIcon({
    bool initiallySelected,
    void Function(bool) onSelected,
    this.icon,
    SelectableController controller,
  }) : super(
            initiallySelected: initiallySelected ?? false,
            onSelected: onSelected,
            controller: controller);

  final Icon icon;

  @override
  _SelectableIconState createState() => _SelectableIconState(icon);
}

class _SelectableIconState extends SelectableState
    with SingleTickerProviderStateMixin {
  _SelectableIconState(this.icon);

  Icon icon;
  AnimationController animationController;
  CurvedAnimation animation;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initiallySelected;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.selectableState = this;

    if (!isSelected) animationController.value = 0;

    return GestureDetector(
      onTap: () {
        setState(
          () {
            isSelected = !isSelected;
            widget.onSelected(isSelected);
            animationController.forward();
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
          child: icon,
          builder: (BuildContext context, Widget child) {
            return Transform.scale(
              scale: isSelected ? animation.value * 0.6 + 1 : 1,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
