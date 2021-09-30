import 'package:acs_upb_mobile/pages/search/view/people_search_results.dart';
import 'package:acs_upb_mobile/pages/search/view/search_page.dart';
import 'package:acs_upb_mobile/resources/remote_config.dart';
import 'package:acs_upb_mobile/widgets/search_bar.dart';
import 'package:flutter/material.dart';

import 'classes_search_results.dart';

class SearchDropdown extends StatefulWidget {
  const SearchDropdown({Key key}) : super(key: key);

  @override
  _SearchDropdownState createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  String query = '';

  OverlayEntry _overlayEntry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).addListener(_removeOverlay);
  }

  void _createOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height,
          width: size.width,
          child: Material(
            elevation: 1,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                PeopleSearchResults(query: query),
                ClassesSearchResults(query: query),
                if (RemoteConfigService.chatEnabled && query.isNotEmpty)
                  ChatbotIntro()
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchWidget(
      onTap: () => setState(_createOverlay),
      onSearch: (searchText) => {
        setState(() {
          query = searchText;
          _createOverlay();
        })
      },
      cancelCallback: () => {setState(() => query = '')},
      searchClosed: false,
    );
  }
}
