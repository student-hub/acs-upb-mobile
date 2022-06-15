import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../resources/locale_provider.dart';
import '../resources/theme.dart';

class FilterChipFormField extends ChipFormField<Map<Localizable, bool>> {
  FilterChipFormField({
    @required final Map<Localizable, bool> initialValues,
    @required final IconData icon,
    @required final String label,
    final Key key,
  }) : super(
          key: key,
          icon: icon,
          label: label,
          initialValues: initialValues,
          validator: (final selection) {
            if (selection.values.where((final e) => e != false).isEmpty) {
              return S.current.warningYouNeedToSelectAtLeastOne;
            }
            return null;
          },
          contentBuilder: (final state) {
            final labels = state.value.keys.toList();
            return ListView.builder(
              itemCount: labels.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (final context, final index) {
                return Row(
                  children: [
                    FilterChip(
                      label: Text(
                        labels[index].toLocalizedString(),
                        style: Theme.of(context).chipTextStyle(
                            selected: state.value[labels[index]]),
                      ),
                      selected: state.value[labels[index]],
                      onSelected: (final selected) {
                        state.value[labels[index]] = selected;
                        state.didChange(state.value);
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                );
              },
            );
          },
        );
}

class ChipFormField<T> extends FormField<T> {
  ChipFormField({
    @required final IconData icon,
    @required final String label,
    @required final Widget Function(FormFieldState<T> state) contentBuilder,
    final Widget Function(FormFieldState<T>) trailingBuilder,
    final T initialValues,
    final String Function(T) validator,
    final Key key,
  }) : super(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: initialValues,
          key: key,
          validator: validator,
          builder: (final state) {
            final context = state.context;
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 0),
                          Icon(icon, color: Theme.of(context).formIconColor),
                          const SizedBox(width: 12),
                          Text(
                            label,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          Expanded(child: Container()),
                          if (trailingBuilder != null) trailingBuilder(state),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const SizedBox(width: 0),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: contentBuilder(state),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(
                        thickness: 0.7,
                        color: state.hasError
                            ? Theme.of(context).errorColor
                            : Theme.of(context).hintColor),
                    if (state.hasError)
                      Text(
                        state.errorText,
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).errorColor.withOpacity(1)),
                      ),
                  ],
                ),
              ),
            );
          },
        );
}
