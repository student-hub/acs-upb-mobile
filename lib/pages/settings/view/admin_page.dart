import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/service/admin_provider.dart';
import 'package:acs_upb_mobile/pages/settings/view/request_card.dart';
import 'package:acs_upb_mobile/widgets/error_page.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key key}) : super(key: key);
  static const String routeName = '/admin';

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  bool all = false;

  @override
  Widget build(BuildContext context) {
    if (checkUserIsAdmin()) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      return AppScaffold(
        actions: [
          AppScaffoldAction(
              icon: FeatherIcons.filter,
              tooltip: S.current.navigationFilter,
              items: {
                S.current.filterMenuShowAll: () {
                  if (!all) {
                    setState(() => all = true);
                  } else {
                    AppToast.show(S.current.warningFilterAlreadyAll);
                  }
                },
                S.current.filterMenuShowUnprocessed: () {
                  if (all) {
                    setState(() => all = false);
                  } else {
                    AppToast.show(S.current.warningFilterAlreadyUnprocessed);
                  }
                },
              })
        ],
        title: Text(S.current.navigationAdmin),
        body: FutureBuilder(
            future: all
                ? adminProvider.fetchAllRequestIds()
                : adminProvider.fetchUnprocessedRequestIds(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount:
                      snapshot.data?.length != null ? snapshot.data.length : 0,
                  itemBuilder: (context, index) {
                    return RequestCard(
                      requestId: snapshot.data[index],
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      );
    } else {
      return AppScaffold(
        body: ErrorPage(
          imgPath: 'assets/illustrations/undraw_access_denied.png',
          errorMessage: S.current.errorDontHavePermissions,
        ),
      );
    }
  }

  bool checkUserIsAdmin() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated && !authProvider.isAnonymous) {
      final user = authProvider.currentUserFromCache;
      if (user.isAdmin) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
