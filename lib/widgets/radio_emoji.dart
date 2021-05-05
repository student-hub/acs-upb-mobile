import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/material.dart';

class EmojiFormField extends FormField<Map<int, bool>> {
  EmojiFormField({
    @required Map<int, bool> initialValues,
    @required String question,
    FormFieldSetter<Map<int, bool>> onSaved,
    String Function(Map<int, bool>) validator,
    int questionIndex,
    Map<int, Map<int, bool>> responses,
    Key key,
  }) : super(
          key: key,
          validator: validator,
          onSaved: onSaved,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: initialValues,
          builder: (state) {
            final context = state.context;
            final List<Icon> emojis = [
              const Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
                size: 30,
              ),
              const Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.redAccent,
                size: 30,
              ),
              const Icon(
                Icons.sentiment_neutral,
                color: Colors.amber,
                size: 30,
              ),
              const Icon(
                Icons.sentiment_satisfied,
                color: Colors.lightGreen,
                size: 30,
              ),
              const Icon(
                Icons.sentiment_very_satisfied,
                color: Colors.green,
                size: 30,
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
                              //TODO
                              state.value[i] = selected;
                              state.value[emojiControllers.indexOf(c)] =
                                  !selected;
                            }
                          }
                          controller.select();
                          state.value[i] = selected;
                          state.didChange(state.value);
                          responses.addAll({questionIndex: null});
                          responses.update(
                              questionIndex, (value) => state.value);
                          //print('2. ${state.value}');
                        } else {
                          controller.deselect();
                          state.value[i] = selected;
                          state.didChange(state.value);
                          responses.addAll({questionIndex: null});
                          responses.update(
                              questionIndex, (value) => state.value);
                          //print('3. ${state.value}');
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
                const SizedBox(height: 24),
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
                const SizedBox(height: 12),
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

class _SelectableIconState extends SelectableState {
  _SelectableIconState(this.icon);

  Icon icon;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.selectableState = this;

    return GestureDetector(
      onTap: () {
        setState(
          () {
            isSelected = !isSelected;
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
        child: AnimatedContainer(
          height: isSelected ? 40 : 10,
          width: isSelected ? 70 : 30,
          duration: const Duration(milliseconds: 500),
          child: icon,
        ),
      ),
    );
  }
}
