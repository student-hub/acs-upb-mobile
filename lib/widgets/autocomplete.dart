// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This code was taken from the following resource:
// https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/autocomplete.dart
// AutocompleteCore feature is currently in 1.24.0-6.0.pre Flutter version
// and it has not reached production yet, reason why we had to copy the code.
// This file will be removed as soon as it is released officially.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

String _displayStringForOption(dynamic option) => option.toString();

/// {@macro flutter.widgets.RawAutocomplete.RawAutocomplete}
///
/// {@tool dartpad --template=freeform}
/// This example shows how to create a very basic Autocomplete widget using the
/// default UI.
///
/// ```dart imports
/// import 'package:flutter/material.dart';
/// ```
///
/// ```dart
/// class AutocompleteBasicExample extends StatelessWidget {
///   AutocompleteBasicExample({Key? key}) : super(key: key);
///
///   final List<String> _kOptions = <String>[
///     'aardvark',
///     'bobcat',
///     'chameleon',
///   ];
///
///   @override
///   Widget build(BuildContext context) {
///     return Autocomplete<String>(
///       optionsBuilder: (TextEditingValue textEditingValue) {
///         if (textEditingValue.text == '') {
///           return const Iterable<String>.empty();
///         }
///         return _kOptions.where((String option) {
///           return option.contains(textEditingValue.text.toLowerCase());
///         });
///       },
///       onSelected: (String selection) {
///         print('You just selected $selection');
///       },
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// {@tool dartpad --template=freeform}
/// This example shows how to create an Autocomplete widget with a custom type.
/// Try searching with text from the name or email field.
///
/// ```dart imports
/// import 'package:flutter/material.dart';
/// ```
///
/// ```dart
/// class User {
///   const User({
///     required this.email,
///     required this.name,
///   });
///
///   final String email;
///   final String name;
///
///   @override
///   String toString() {
///     return '$name, $email';
///   }
///
///   @override
///   bool operator ==(Object other) {
///     if (other.runtimeType != runtimeType)
///       return false;
///     return other is User
///         && other.name == name
///         && other.email == email;
///   }
///
///   @override
///   int get hashCode => hashValues(email, name);
/// }
///
/// class AutocompleteBasicUserExample extends StatelessWidget {
///   AutocompleteBasicUserExample({Key? key}) : super(key: key);
///
///   static final List<User> _userOptions = <User>[
///     User(name: 'Alice', email: 'alice@example.com'),
///     User(name: 'Bob', email: 'bob@example.com'),
///     User(name: 'Charlie', email: 'charlie123@gmail.com'),
///   ];
///
///   static String _displayStringForOption(User option) => option.name;
///
///   @override
///   Widget build(BuildContext context) {
///     return Autocomplete<User>(
///       displayStringForOption: _displayStringForOption,
///       optionsBuilder: (TextEditingValue textEditingValue) {
///         if (textEditingValue.text == '') {
///           return const Iterable<User>.empty();
///         }
///         return _userOptions.where((User option) {
///           return option.toString().contains(textEditingValue.text.toLowerCase());
///         });
///       },
///       onSelected: (User selection) {
///         print('You just selected ${_displayStringForOption(selection)}');
///       },
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [RawAutocomplete], which is what Autocomplete is built upon, and which
///    contains more detailed examples.
class Autocomplete<T extends Object> extends StatelessWidget {
  /// Creates an instance of [Autocomplete].
  const Autocomplete({
    @required this.optionsBuilder,
    Key key,
    this.displayStringForOption = _displayStringForOption,
    this.fieldViewBuilder = _defaultFieldViewBuilder,
    this.onSelected,
    this.optionsViewBuilder,
  })  : assert(optionsBuilder != null),
        super(key: key);

  /// {@macro flutter.widgets.RawAutocomplete.displayStringForOption}
  final AutocompleteOptionToString<T> displayStringForOption;

  /// {@macro flutter.widgets.RawAutocomplete.fieldViewBuilder}
  ///
  /// If not provided, will build a standard Material-style text field by
  /// default.
  final AutocompleteFieldViewBuilder fieldViewBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.onSelected}
  final AutocompleteOnSelected<T> onSelected;

  /// {@macro flutter.widgets.RawAutocomplete.optionsBuilder}
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.optionsViewBuilder}
  ///
  /// If not provided, will build a standard Material-style list of results by
  /// default.
  final AutocompleteOptionsViewBuilder<T> optionsViewBuilder;

  static Widget _defaultFieldViewBuilder(
      BuildContext context,
      TextEditingController textEditingController,
      FocusNode focusNode,
      VoidCallback onFieldSubmitted) {
    return _AutocompleteField(
      focusNode: focusNode,
      textEditingController: textEditingController,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: fieldViewBuilder,
      optionsBuilder: optionsBuilder,
      optionsViewBuilder: optionsViewBuilder ??
          (BuildContext context, AutocompleteOnSelected<T> onSelected,
              Iterable<T> options) {
            return _AutocompleteOptions<T>(
              displayStringForOption: displayStringForOption,
              onSelected: onSelected,
              options: options,
            );
          },
      onSelected: onSelected,
    );
  }
}

// The default Material-style Autocomplete text field.
class _AutocompleteField extends StatelessWidget {
  const _AutocompleteField({
    @required this.focusNode,
    @required this.textEditingController,
    @required this.onFieldSubmitted,
    Key key,
  }) : super(key: key);

  final FocusNode focusNode;

  final VoidCallback onFieldSubmitted;

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      focusNode: focusNode,
      onFieldSubmitted: (String value) {
        onFieldSubmitted();
      },
    );
  }
}

// The default Material-style Autocomplete options.
class _AutocompleteOptions<T extends Object> extends StatelessWidget {
  const _AutocompleteOptions({
    @required this.displayStringForOption,
    @required this.onSelected,
    @required this.options,
    Key key,
  }) : super(key: key);

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        child: Container(
          height: 200,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(displayStringForOption(option)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
