import 'package:dart_date/dart_date.dart' show Interval;
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:supercharged/supercharged.dart';
import 'package:timetable/timetable.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../navigation/routes.dart';
import '../../../widgets/button.dart';
import '../../../widgets/dialog.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../../classes/service/class_provider.dart';
import '../../classes/view/classes_page.dart';
import '../../filter/service/filter_provider.dart';
import '../../filter/view/filter_page.dart';
import '../../settings/service/request_provider.dart';
import '../../timetable/timetable_utils.dart';
import '../model/events/uni_event.dart';
import '../service/uni_event_provider.dart';
import 'events/add_event_view.dart';
import 'events/all_day_event_widget.dart';
import 'events/event_widget.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage>
    with TickerProviderStateMixin {
  TimeController _timeController;
  DateController _dateController;

  @override
  void dispose() {
    _timeController?.dispose();
    _dateController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    _dateController ??= DateController(
      initialDate: DateTimeTimetable.today(),
      visibleRange: VisibleDateRange.week(startOfWeek: DateTime.monday),
    );

    if (_timeController == null) {
      _timeController = TimeController(
        initialRange: TimeRange(7.hours + 55.minutes, 20.hours + 5.minutes),
        // TODO(IoanaAlexandru): Make initialTimeRange customizable in settings, #99
        maxRange: TimeRange(0.hours, 24.hours),
      );

      if (authProvider.isAuthenticated && !authProvider.isAnonymous) {
        scheduleDialog(context);
      }
    }

    return AppScaffold(
      title: AnimatedBuilder(
        animation: _dateController,
        builder: (context, child) {
          return Text(authProvider.isAuthenticated && !authProvider.isAnonymous
              ? _dateController.currentMonth.titleCase
              : S.current.navigationTimetable);
        },
      ),
      needsToBeAuthenticated: true,
      leading: AppScaffoldAction(
        icon: Icons.today_outlined,
        onPressed: () {
          _dateController.animateToToday(vsync: this);
        },
        tooltip: S.current.actionJumpToToday,
      ),
      actions: [
        AppScaffoldAction(
          icon: FeatherIcons.bookOpen,
          tooltip: S.current.navigationClasses,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<ChangeNotifierProvider>(
              builder: (_) => ChangeNotifierProvider.value(
                  value: Provider.of<ClassProvider>(context),
                  child: const ClassesPage()),
            ),
          ),
        ),
        AppScaffoldAction(
          icon: FeatherIcons.filter,
          tooltip: S.current.navigationFilter,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<FilterPage>(builder: (_) => const FilterPage()),
          ),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            ValueListenableBuilder<DatePageValue>(
              valueListenable: _dateController,
              builder: (context, value, child) {
                final Stream<List<UniEventInstance>> eventsInRange =
                    Provider.of<UniEventProvider>(context, listen: true)
                        .getEventsIntersecting(
                  Interval(
                    // Events are preloaded for previous, current and next page
                    DateTimeTimetable.dateFromPage(
                        value.page.floor() - value.visibleDayCount),
                    DateTimeTimetable.dateFromPage(
                      value.page.ceil() + value.visibleDayCount * 2,
                    ),
                  ),
                );

                return StreamBuilder<List<UniEventInstance>>(
                  stream: eventsInRange,
                  builder: (context,
                      AsyncSnapshot<List<UniEventInstance>> snapshot) {
                    if (snapshot.hasError) {
                      AppToast.show(S.current.errorSomethingWentWrong);
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          AppToast.show(S.current.errorSomethingWentWrong);
                          return const Center(
                              child: CircularProgressIndicator());
                        case ConnectionState.waiting:
                          break;
                        case ConnectionState.active:
                          break;
                        case ConnectionState.done:
                          break;
                      }
                      return TimetableConfig<UniEventInstance>(
                        eventProvider:
                            eventProviderFromFixedList(snapshot.data ?? []),
                        child: child,
                        dateController: _dateController,
                        timeController: _timeController,
                        eventBuilder: (context, event) => UniEventWidget(event),
                        allDayEventBuilder: (context, event, info) =>
                            UniAllDayEventWidget(event, info: info),
                        callbacks: TimetableCallbacks(
                          onDateTimeBackgroundTap: (dateTime) {
                            final user = Provider.of<AuthProvider>(context,
                                    listen: false)
                                .currentUserFromCache;
                            if (user.canAddPublicInfo) {
                              Navigator.of(context).push(
                                MaterialPageRoute<AddEventView>(
                                  builder: (_) => ChangeNotifierProxyProvider<
                                      AuthProvider, FilterProvider>(
                                    create: (_) => FilterProvider(),
                                    update: (context, authProvider,
                                        filterProvider) {
                                      return filterProvider
                                        ..updateAuth(authProvider);
                                    },
                                    child: AddEventView(
                                      initialEvent: UniEvent(
                                          start: dateTime.copyWith(isUtc: true),
                                          duration: const Duration(hours: 2),
                                          id: null),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              AppToast.show(S.current.errorPermissionDenied);
                            }
                          },
                        ),
                      );
                    }
                  },
                );
              },
              child: MultiDateTimetable<UniEventInstance>(),
            )
          ],
        ),
      ),
    );
  }

  Future<void> scheduleDialog(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final classProvider =
            Provider.of<ClassProvider>(context, listen: false);
        final filterProvider =
            Provider.of<FilterProvider>(context, listen: false);
        final requestProvider =
            Provider.of<RequestProvider>(context, listen: false);

        // Fetch user classes, request necessary info from providers so it's
        // cached when we check in the dialog
        final user = authProvider.currentUserFromCache;
        await classProvider.fetchClassHeaders(uid: user.uid);
        await filterProvider.fetchFilter();
        await requestProvider.userAlreadyRequested(user.uid);

        // Slight delay between last frame and dialog
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Show dialog if there are no events
        if (!mounted) return;
        final eventProvider =
            Provider.of<UniEventProvider>(context, listen: false);

        if (eventProvider != null) {
          if (eventProvider.empty) {
            await showDialog<String>(
              context: context,
              builder: buildDialog,
            );
          }
        }
      },
    );
  }

  Widget buildDialog(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final filterProvider = Provider.of<FilterProvider>(context);
    final user = authProvider.currentUserFromCache;

    if (classProvider.userClassHeadersCache?.isEmpty ?? true) {
      return AppDialog(
        title: S.current.warningNoEvents,
        content: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1,
              children: [
                TextSpan(text: '${S.current.infoYouNeedToSelect} '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: Icon(
                    FeatherIcons.bookOpen,
                    size: Theme.of(context).textTheme.subtitle1.fontSize + 2,
                  ),
                ),
                TextSpan(text: ' ${S.current.infoClasses}.'),
              ],
            ),
          ),
        ],
        actions: [
          AppButton(
            text: S.current.actionChooseClasses,
            width: 130,
            onTap: () async {
              // Pop the dialog
              Navigator.of(context).pop();
              // Push the Add classes page
              await Navigator.of(context).push(
                MaterialPageRoute<ChangeNotifierProvider>(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: classProvider,
                    child: FutureBuilder(
                      future: classProvider.fetchUserClassIds(user.uid),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return AddClassesPage(
                              initialClassIds: snap.data,
                              onSave: (classIds) async {
                                await classProvider.setUserClassIds(
                                    classIds, authProvider.uid);
                                if (!mounted) return;
                                Navigator.pop(context);
                              });
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          )
        ],
      );
    } else if ((filterProvider.cachedFilter?.relevantNodes?.length ?? 0) < 6) {
      return AppDialog(
        title: S.current.warningNoEvents,
        content: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1,
              children: [
                TextSpan(text: '${S.current.infoMakeSureGroupIsSelected} '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: Icon(
                    FeatherIcons.filter,
                    size: Theme.of(context).textTheme.subtitle1.fontSize + 2,
                  ),
                ),
                TextSpan(text: ' ${S.current.navigationFilter.toLowerCase()}.'),
              ],
            ),
          ),
        ],
        actions: [
          AppButton(
            text: S.current.actionOpenFilter,
            width: 130,
            onTap: () async {
              // Pop the dialog
              Navigator.of(context).pop();
              // Push the Filter page
              await Navigator.pushNamed(context, Routes.filter);
            },
          )
        ],
      );
    } else if (user.permissionLevel < 3) {
      // TODO(IoanaAlexandru): Check if user already requested and show a different message
      return AppDialog(
        title: S.current.warningNoEvents,
        content: [Text(S.current.messageYouCanContribute)],
        actions: [
          AppButton(
            text: S.current.actionRequestPermissions,
            width: 130,
            onTap: () async {
              // Check if user is verified
              final bool isVerified = await authProvider.isVerified;
              // Pop the dialog
              if (!mounted) return;
              Navigator.of(context).pop();
              // Push the Permissions page
              if (authProvider.isAnonymous) {
                AppToast.show(S.current.messageNotLoggedIn);
              } else if (!isVerified) {
                AppToast.show(S.current.messageEmailNotVerifiedToPerformAction);
              } else {
                await Navigator.of(context)
                    .pushNamed(Routes.requestPermissions);
              }
            },
          )
        ],
      );
    } else {
      return AppDialog(
        title: S.current.warningNoEvents,
        content: [
          RichText(
            key: const ValueKey('no_events_message'),
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1,
              children: [
                TextSpan(text: S.current.messageThereAreNoEventsForSelected),
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: Icon(
                    FeatherIcons.bookOpen,
                    size: Theme.of(context).textTheme.subtitle1.fontSize + 2,
                  ),
                ),
                TextSpan(
                    text:
                        '${S.current.navigationClasses.toLowerCase()} ${S.current.stringAnd} '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: Icon(
                    FeatherIcons.filter,
                    size: Theme.of(context).textTheme.subtitle1.fontSize + 2,
                  ),
                ),
                TextSpan(text: ' ${S.current.navigationFilter.toLowerCase()}.'),
              ],
            ),
          ),
        ],
      );
    }
  }
}
