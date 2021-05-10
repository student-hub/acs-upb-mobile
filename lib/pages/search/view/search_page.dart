import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  String filter = '';
  List<Person> peopleSearched;
  List<Class> classesSearched;
  bool searchClosed = true;

  @override
  void initState() {
    super.initState();
    //final InfoProvider infoProvider = Provider.of<InfoProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.navigationSearch),
      body: ListView(
          children: [
            SearchWidget(
            onSearch: (searchText) => {
              setState(() => filter = searchText)
            },
            cancelCallback: () =>{
              setState(() => filter = '')
            },
            searchClosed: false,
          ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Icon(
                    Icons.photo,
                    size: 100,
                  ),
                  const Icon(
                    Icons.photo,
                    size: 100,
                  ),
                  const Icon(
                    Icons.photo,
                    size: 100,
                  ),
                  const Icon(
                    Icons.photo,
                    size: 100,
                  ),
                  const Icon(
                    Icons.photo,
                    size: 100,
                  )
                ],
              ),
            ),
          ],
        ),
    );
  }

}