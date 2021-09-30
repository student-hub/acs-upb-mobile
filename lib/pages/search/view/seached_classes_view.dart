import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/service/navigator.dart';
import 'package:acs_upb_mobile/navigation/view/scaffold.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/widgets/class_icon.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedClassesView extends StatelessWidget {
  const SearchedClassesView({this.classHeaders});

  static const String routeName = 'classes/search';

  final List<ClassHeader> classHeaders;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(S.current.navigationSearchResults),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: classHeaders.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: GestureDetector(
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: CircleAvatar(
                      backgroundColor: classHeaders[index].colorFromAcronym,
                      child: Container(
                        width: 30,
                        child: Align(
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            classHeaders[index].acronym,
                            minFontSize: 0,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(classHeaders[index].name),
                  )
                ]),
                onTap: () {
                  final currentUser =
                      Provider.of<AuthProvider>(context, listen: false)
                          .currentUserFromCache;
                  print('CurrentUser: $currentUser');
                  if (currentUser != null) {
                    AppNavigator.push(
                        context,
                        MaterialPageRoute<ClassView>(
                          builder: (_) =>
                              ClassView(classHeader: classHeaders[index]),
                        ),
                        webPath:
                            '${ClassView.routeName}?id=${classHeaders[index].id}');
                  } else {
                    AppToast.show(S.current.warningAuthenticationNeeded);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
