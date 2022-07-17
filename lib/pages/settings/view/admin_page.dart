import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../service/admin_provider.dart';
import 'admin_page_admin_requests.dart';
import 'admin_page_roles_requests.dart';
import 'admin_request_card.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({this.tabIndex = 0});
  static const String routeName = '/admin';

  final int tabIndex;

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage>
    with TickerProviderStateMixin {
  int currentTab = 0;
  bool allRequests = false;
  List<Widget> tabs;
  TabController tabController;
  final PageStorageBucket bucket = PageStorageBucket();
  final int tabsLength = 2;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          currentTab = tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: tabsLength,
      initialIndex: widget.tabIndex,
      child: AppScaffold(
        title: Text(S.current.navigationAdmin),
        body: PageStorage(
          child: TabBarView(
            controller: tabController,
            children: [
              AdminPageAdminRequests(
                allRequests: allRequests,
                key: const PageStorageKey('AdminPageAdminRequests'),
              ),
              AdminPageRolesRequests(
                allRequests: allRequests,
                key: const PageStorageKey('AdminPageRolesRequests'),
              ),
            ],
          ),
          bucket: bucket,
        ),
        appBarBottom: _adminNavigationBar(context),
        actions: [
          AppScaffoldAction(
            icon: FeatherIcons.filter,
            tooltip: S.current.navigationFilter,
            items: {
              S.current.filterMenuShowAll: () {
                if (!allRequests) {
                  setState(() => allRequests = true);
                } else {
                  AppToast.show(S.current.warningFilterAlreadyAll);
                }
              },
              S.current.filterMenuShowUnprocessed: () {
                if (allRequests) {
                  setState(() => allRequests = false);
                } else {
                  AppToast.show(S.current.warningFilterAlreadyUnprocessed);
                }
              },
            },
          )
        ],
      ),
    );
  }

  Widget _adminNavigationBar(final BuildContext context) => TabBar(
        controller: tabController,
        tabs: [
          const Tab(text: 'Admin'),
          const Tab(text: 'Roles'),
        ],
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
        indicatorColor: Colors.white,
      );
}
