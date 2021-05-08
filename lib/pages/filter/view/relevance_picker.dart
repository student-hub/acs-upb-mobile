import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/filter/view/filter_page.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class RelevanceController {
  RelevanceController({this.onChanged});

  _RelevancePickerState _state;
  void Function() onChanged;

  String get degree => _state?._filter?.baseNode;

  bool get private =>
      _state?._onlyMeSelected ?? _state?.widget?.defaultPrivate ?? true;

  bool get anyone =>
      _state?._anyoneSelected ??
      _state?.widget != null &&
          _state.widget.filterProvider.defaultRelevance == null;

  List<String> get customRelevance {
    final relevance = <String>[];
    if (_state?._customSelected != null) {
      _state._customSelected.forEach((node, selected) {
        if (selected) {
          relevance.add(node);
        }
      });
    }

    return relevance.isEmpty ? null : relevance;
  }
}

class RelevancePicker extends StatefulWidget {
  const RelevancePicker({
    @required this.filterProvider,
    this.canBePrivate = true,
    this.canBeForEveryone = true,
    bool defaultPrivate,
    this.controller,
  }) : defaultPrivate = (defaultPrivate ?? true) && canBePrivate;

  final FilterProvider filterProvider;

  /// Whether 'Only me' is an option (this overrides [defaultPrivate])
  final bool canBePrivate;

  /// Whether 'Anyone' is an option
  final bool canBeForEveryone;

  /// Whether the 'Only me' option should be enabled by default
  final bool defaultPrivate;

  final RelevanceController controller;

  @override
  _RelevancePickerState createState() => _RelevancePickerState();
}

class _RelevancePickerState extends State<RelevancePicker> {
  // The three relevance options ("Only me", "Anyone" or an arbitrary list of nodes) are mutually exclusive
  // final _onlyMeController = SelectableController();
  // final _anyoneController = SelectableController();
  // Map<String, SelectableController> _customControllers = {};
  bool _onlyMeSelected, _anyoneSelected;
  Map<String, bool> _customSelected;

  User _user;
  Filter _filter;

  Future<void> _fetchUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _user = await authProvider.currentUser;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchFilter() async {
    _filter = await widget.filterProvider.fetchFilter();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchFilter();
    _onlyMeSelected = widget.defaultPrivate ?? true;
    _anyoneSelected = !widget.defaultPrivate &&
        widget.filterProvider.defaultRelevance == null;
  }

  Widget _customRelevanceButton() {
    final buttonColor = _user?.canAddPublicInfo ?? false
        ? Theme.of(context).accentColor
        : Theme.of(context).hintColor;

    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () {
          if (_user?.canAddPublicInfo ?? false) {
            Navigator.of(context)
                .push(MaterialPageRoute<ChangeNotifierProvider>(
              builder: (_) => ChangeNotifierProvider.value(
                value: widget.filterProvider,
                child: FilterPage(
                  title: S.current.labelRelevance,
                  buttonText: S.current.buttonSet,
                  canBeForEveryone: widget.canBeForEveryone,
                  info:
                      '${S.current.infoRelevanceNothingSelected} ${S.current.infoRelevance}',
                  hint: S.current.infoRelevanceExample,
                  onSubmit: () async {
                    // // Deselect all options
                    // _onlyMeController.deselect();
                    // _anyoneController.deselect();
                    //
                    // // Select the new options
                    // await _fetchFilter();
                    // if (_filter.relevantLeaves.contains('All')) {
                    //   _anyoneController.select();
                    // } else {
                    //   for (final controller in _customControllers.values) {
                    //     controller.select();
                    //   }
                    // }
                  },
                ),
              ),
            ));
          } else {
            AppToast.show(S.current.warningNoPermissionToAddPublicWebsite);
          }
        },
        child: Row(
          children: <Widget>[
            Text(
              S.current.labelCustom,
              style: Theme.of(context)
                  .accentTextTheme
                  .subtitle2
                  .copyWith(color: buttonColor),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: buttonColor,
              size: Theme.of(context).textTheme.subtitle2.fontSize,
            )
          ],
        ),
      ),
    );
  }

  void _onCustomSelected(bool selected) => setState(() {
        if (_user?.canAddPublicInfo ?? false) {
          if (selected) {
            _onlyMeSelected = false;
            _anyoneSelected = false;
            widget.controller?.onChanged();
          }
        } else {
          AppToast.show(S.current.warningNoPermissionToAddPublicWebsite);
        }
      });

  Widget _customRelevanceSelectables() {
    final widgets = <Widget>[];

    // Add strings from the filter options
    for (final node in _filter?.relevantLocalizedLeaves(context) ?? []) {
      if (node != 'All') {
        // The "All" case (when nothing is selected in the filter) is handled
        // separately using [_anyoneSelected]

        widgets
          ..add(FilterChip(
            label: node,
            selected:
                (!(_onlyMeSelected ?? false) && !(_anyoneSelected ?? false)) ||
                    (!widget.canBePrivate && !widget.canBeForEveryone),
            onSelected: (selected) => setState(() {
              if (_user?.canAddPublicInfo ?? false) {
                if (selected) {
                  _onlyMeSelected = false;
                  _anyoneSelected = false;
                }
                if (widget.controller?.onChanged != null) {
                  widget.controller.onChanged();
                }
              } else {
                AppToast.show(S.current.warningNoPermissionToAddPublicWebsite);
              }
            }),
            // disabled: !(_user?.canAddPublicInfo ?? false),
          ))
          ..add(const SizedBox(width: 10));
      }
    }

    // Add the provided website relevance strings, if applicable
    // These are selected by default
    for (final node in widget.filterProvider.defaultRelevance ?? []) {
      if (!_customSelected.containsKey(node)) {
        final controller = SelectableController();
        _customSelected[node] = true;

        widgets
          ..add(const SizedBox(width: 10))
          ..add(FilterChip(
            label: node,
            selected: true,
            onSelected: _onCustomSelected,
            // disabled: !(_user?.canAddPublicInfo ?? false),
          ));
      }
    }

    return Row(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null) {
      widget.controller._state = this;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12),
      child: Row(
        children: <Widget>[
          Icon(FeatherIcons.filter,
              color: CustomIcons.formIconColor(Theme.of(context))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            S.current.labelRelevance,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .apply(color: Theme.of(context).hintColor),
                          ),
                        ),
                        _customRelevanceButton(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                if (widget.canBePrivate)
                                  Row(
                                    children: [
                                      FilterChip(
                                        label: Text(S.current.relevanceOnlyMe),
                                        selected: _onlyMeSelected,
                                        onSelected: (selected) => setState(() {
                                          if (_user?.canAddPublicInfo ??
                                              false) {
                                            if (selected) {
                                              _anyoneSelected = false;
                                              for (final label
                                                  in _customSelected.keys) {
                                                _customSelected[label] = false;
                                              }
                                            } else {
                                              _anyoneSelected = true;
                                            }
                                          } else {
                                            _onlyMeSelected = true;
                                          }
                                          widget.controller?.onChanged();
                                        }),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                if (widget.canBeForEveryone)
                                  Row(
                                    children: [
                                      FilterChip(
                                        label: Text(S.current.relevanceAnyone),
                                        selected: _anyoneSelected,
                                        onSelected: (selected) => setState(() {
                                          if (_user?.canAddPublicInfo ??
                                              false) {
                                            if (selected) {
                                              // Deselect all other options
                                              _onlyMeSelected = false;
                                              for (final label
                                                  in _customSelected.keys) {
                                                _customSelected[label] = false;
                                              }
                                            } else {
                                              _onlyMeSelected = true;
                                            }
                                          } else {
                                            AppToast.show(S
                                                .of(context)
                                                .warningNoPermissionToAddPublicWebsite);
                                          }
                                        }),
                                        // disabled:
                                        //     !(_user?.canAddPublicInfo ?? false),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                _customRelevanceSelectables(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
