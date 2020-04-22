import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/filter/view/filter_page.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/website_view.dart';
import 'package:acs_upb_mobile/pages/settings/settings_page.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockStorageProvider extends Mock implements StorageProvider {}

class MockWebsiteProvider extends Mock implements WebsiteProvider {}

class MockFilterProvider extends Mock implements FilterProvider {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  AuthProvider mockAuthProvider;
  StorageProvider mockStorageProvider;
  WebsiteProvider mockWebsiteProvider;
  FilterProvider mockFilterProvider;

  // Test layout for different screen sizes
  List<Size> screenSizes = [
    // Phone
    Size(1080, 1920), Size(720, 1280), // Standard
    Size(2200, 2480), Size(1536, 2151), // Foldable
    Size(480, 800), Size(480, 854), // WVGA
    /* For some reason, QVGA sizes give weird overflow errors that I can't
    replicate in the emulator with the same size, so I'll leave these commented
    for now:
    Size(240, 432), Size(240, 400), Size(320, 480), Size(240, 320), // QVGA
   */
    // Tablet
    Size(1800, 2560), Size(1536, 2048), Size(1200, 1920),
    Size(1600, 2560), Size(600, 1024), Size(800, 1280),
  ];

  // Add landscape mode sizes
  screenSizes.addAll(
      List.from(screenSizes).map((size) => Size(size.height, size.width)));

  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    PrefService.enableCaching();
    PrefService.cache = {};
    PrefService.setString('language', 'en');

    // Pretend an anonymous user is already logged in
    mockAuthProvider = MockAuthProvider();
    when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
    // ignore: invalid_use_of_protected_member
    when(mockAuthProvider.hasListeners).thenReturn(false);
    when(mockAuthProvider.isAnonymous).thenReturn(true);
    when(mockAuthProvider.isAuthenticatedFromService)
        .thenAnswer((_) => Future.value(true));
    when(mockAuthProvider.currentUser)
        .thenAnswer((realInvocation) => Future.value(null));

    mockStorageProvider = MockStorageProvider();
    // ignore: invalid_use_of_protected_member
    when(mockStorageProvider.hasListeners).thenReturn(false);

    mockWebsiteProvider = MockWebsiteProvider();
    // ignore: invalid_use_of_protected_member
    when(mockWebsiteProvider.hasListeners).thenReturn(false);
    when(mockWebsiteProvider.deleteWebsite(any, context: anyNamed('context')))
        .thenAnswer((realInvocation) => Future.value(true));
    when(mockWebsiteProvider.fetchWebsites(any))
        .thenAnswer((_) => Future.value([
              Website(
                id: '1',
                relevance: null,
                category: WebsiteCategory.learning,
                iconPath: 'icons/websites/moodle.png',
                infoByLocale: {'en': 'info-en', 'ro': 'info-ro'},
                label: 'Moodle1',
                link: 'http://acs.curs.pub.ro/',
                isPrivate: false,
              ),
              Website(
                id: '2',
                relevance: null,
                category: WebsiteCategory.learning,
                iconPath: 'icons/websites/ocw.png',
                infoByLocale: {},
                label: 'OCW1',
                link: 'https://ocw.cs.pub.ro/',
                isPrivate: false,
              ),
              Website(
                id: '3',
                relevance: null,
                category: WebsiteCategory.learning,
                iconPath: 'icons/websites/moodle.png',
                infoByLocale: {'en': 'info-en', 'ro': 'info-ro'},
                label: 'Moodle2',
                link: 'http://acs.curs.pub.ro/',
                isPrivate: false,
              ),
              Website(
                id: '4',
                relevance: null,
                category: WebsiteCategory.learning,
                iconPath: 'icons/websites/ocw.png',
                infoByLocale: {},
                label: 'OCW2',
                link: 'https://ocw.cs.pub.ro/',
                isPrivate: false,
              ),
              Website(
                id: '5',
                relevance: null,
                category: WebsiteCategory.association,
                iconPath: 'icons/websites/lsac.png',
                infoByLocale: {},
                label: 'LSAC1',
                link: 'https://lsacbucuresti.ro/',
                isPrivate: false,
              ),
              Website(
                id: '6',
                relevance: null,
                category: WebsiteCategory.administrative,
                iconPath: 'icons/websites/lsac.png',
                infoByLocale: {},
                label: 'LSAC2',
                link: 'https://lsacbucuresti.ro/',
                isPrivate: false,
              ),
              Website(
                id: '7',
                relevance: null,
                category: WebsiteCategory.resource,
                iconPath: 'icons/websites/lsac.png',
                infoByLocale: {},
                label: 'LSAC3',
                link: 'https://lsacbucuresti.ro/',
                isPrivate: false,
              ),
              Website(
                id: '8',
                relevance: null,
                category: WebsiteCategory.other,
                iconPath: 'icons/websites/lsac.png',
                infoByLocale: {},
                label: 'LSAC4',
                link: 'https://lsacbucuresti.ro/',
                isPrivate: false,
              ),
            ]));

    mockFilterProvider = MockFilterProvider();
    // ignore: invalid_use_of_protected_member
    when(mockFilterProvider.hasListeners).thenReturn(false);
    when(mockFilterProvider.filterEnabled).thenReturn(true);
    when(mockFilterProvider.fetchFilter(any))
        .thenAnswer((_) => Future.value(Filter(
                localizedLevelNames: [
                  {'en': 'Degree', 'ro': 'Nivel de studiu'},
                  {'en': 'Major', 'ro': 'Specializare'},
                  {'en': 'Year', 'ro': 'An'},
                  {'en': 'Series', 'ro': 'Serie'},
                  {'en': 'Group', 'ro': 'Group'}
                ],
                root: FilterNode(name: 'All', value: true, children: [
                  FilterNode(name: 'BSc', value: true, children: [
                    FilterNode(name: 'CTI', value: true, children: [
                      FilterNode(name: 'CTI-1', value: true, children: [
                        FilterNode(name: '1-CA'),
                        FilterNode(
                          name: '1-CB',
                          value: true,
                          children: [
                            FilterNode(name: '311CB'),
                            FilterNode(name: '312CB'),
                            FilterNode(name: '313CB'),
                            FilterNode(
                              name: '314CB',
                              value: true,
                            ),
                          ],
                        ),
                        FilterNode(name: '1-CC'),
                        FilterNode(
                          name: '1-CD',
                          children: [
                            FilterNode(name: '311CD'),
                            FilterNode(name: '312CD'),
                            FilterNode(name: '313CD'),
                            FilterNode(name: '314CD'),
                          ],
                        ),
                      ]),
                      FilterNode(
                        name: 'CTI-2',
                      ),
                      FilterNode(
                        name: 'CTI-3',
                      ),
                      FilterNode(
                        name: 'CTI-4',
                      ),
                    ]),
                    FilterNode(name: 'IS')
                  ]),
                  FilterNode(name: 'MSc', children: [
                    FilterNode(
                      name: 'IA',
                    ),
                    FilterNode(name: 'SPRC'),
                  ])
                ]))));
  });

  group('Home', () {
    for (var size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider, child: MyApp()));
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
        // Open home
        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
      });
    }
  });

  group('Timetable', () {
    for (var size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider, child: MyApp()));
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
        // Open timetable
        await tester.tap(find.byIcon(Icons.calendar_today));
        await tester.pumpAndSettle();

        // TODO: Replace with page when implemented
        expect(find.text('Timetable'), findsNWidgets(2));
      });
    }
  });

  group('Map', () {
    for (var size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider, child: MyApp()));
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
        // Open map
        await tester.tap(find.byIcon(Icons.map));
        await tester.pumpAndSettle();

        // TODO: Replace with page when implemented
        expect(find.text('Map'), findsNWidgets(2));
      });
    }
  });

  group('Portal', () {
    for (var size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
                create: (_) => mockAuthProvider),
            ChangeNotifierProvider<StorageProvider>(
                create: (_) => mockStorageProvider),
            ChangeNotifierProvider<WebsiteProvider>(
                create: (_) => mockWebsiteProvider),
            ChangeNotifierProvider<FilterProvider>(
                create: (_) => mockFilterProvider),
          ],
          child: MyApp(),
        ));
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
        // Open portal
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();

        expect(find.byType(PortalPage), findsOneWidget);
      });
    }
  });

  group('Profile', () {
    for (var size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider, child: MyApp()));
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
        // Open profile
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        // TODO: Replace with page when implemented
        expect(find.text('Profile'), findsNWidgets(2));
      });
    }
  });

  group('Settings', () {
    for (var size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider, child: MyApp()));
        await tester.pumpAndSettle();

        // Open settings
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();

        expect(find.byType(SettingsPage), findsOneWidget);
      });
    }
  });

  group('Filter', () {
    for (var size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
                create: (_) => mockAuthProvider),
            ChangeNotifierProvider<StorageProvider>(
                create: (_) => mockStorageProvider),
            ChangeNotifierProvider<WebsiteProvider>(
                create: (_) => mockWebsiteProvider),
            ChangeNotifierProvider<FilterProvider>(
                create: (_) => mockFilterProvider),
          ],
          child: MyApp(),
        ));
        await tester.pumpAndSettle();

        // Open filter popup menu
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(CustomIcons.filter));
        await tester.pumpAndSettle();

        // Open filter on portal page
        await tester.tap(find.text('Filter by relevance'));
        await tester.pumpAndSettle();

        expect(find.byType(FilterPage), findsOneWidget);
      });
    }
  });

  group('Add website', () {
    setUp(() {
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(false);
    });

    for (var size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
                create: (_) => mockAuthProvider),
            ChangeNotifierProvider<StorageProvider>(
                create: (_) => mockStorageProvider),
            ChangeNotifierProvider<WebsiteProvider>(
                create: (_) => mockWebsiteProvider),
            ChangeNotifierProvider<FilterProvider>(
                create: (_) => mockFilterProvider),
          ],
          child: MyApp(),
        ));
        await tester.pumpAndSettle();

        // Open portal page
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();

        // Open add website page
        var addWebsiteButton = find.byKey(ValueKey('add_website_associations'));
        await tester.ensureVisible(addWebsiteButton);
        await tester.pumpAndSettle();

        await tester.tap(addWebsiteButton);
        await tester.pumpAndSettle();

        expect(find.byType(WebsiteView), findsOneWidget);
      });
    }
  });

  group('Edit website', () {
    setUp(() {
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(false);
      when(mockAuthProvider.currentUser).thenAnswer((realInvocation) =>
          Future.value(User(
              uid: '1',
              firstName: 'John',
              lastName: 'Doe',
              permissionLevel: 3)));
    });

    for (var size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
                create: (_) => mockAuthProvider),
            ChangeNotifierProvider<StorageProvider>(
                create: (_) => mockStorageProvider),
            ChangeNotifierProvider<WebsiteProvider>(
                create: (_) => mockWebsiteProvider),
            ChangeNotifierProvider<FilterProvider>(
                create: (_) => mockFilterProvider),
          ],
          child: MyApp(),
        ));
        await tester.pumpAndSettle();

        // Open portal page
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();

        // Enable editing
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        // Open edit website page
        await tester.ensureVisible(find.text('LSAC1'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('LSAC1'));
        await tester.pumpAndSettle();

        expect(find.byType(WebsiteView), findsOneWidget);
      });
    }
  });

  group('Delete website', () {
    setUp(() {
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(false);
      when(mockAuthProvider.currentUser).thenAnswer((realInvocation) =>
          Future.value(User(
              uid: '1',
              firstName: 'John',
              lastName: 'Doe',
              permissionLevel: 3)));
    });

    for (var size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
                create: (_) => mockAuthProvider),
            ChangeNotifierProvider<StorageProvider>(
                create: (_) => mockStorageProvider),
            ChangeNotifierProvider<WebsiteProvider>(
                create: (_) => mockWebsiteProvider),
            ChangeNotifierProvider<FilterProvider>(
                create: (_) => mockFilterProvider),
          ],
          child: MyApp(),
        ));
        await tester.pumpAndSettle();

        // Open portal page
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();

        // Enable editing
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        // Open edit website page
        await tester.ensureVisible(find.text('LSAC1'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('LSAC1'));
        await tester.pumpAndSettle();

        // Open delete dialog
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete website'));
        await tester.pumpAndSettle();

        // Cancel
        expect(find.text('Are you sure you want to delete this website?'),
            findsOneWidget);
        await tester.tap(find.text('CANCEL'));
        await tester.pumpAndSettle();

        // Open delete dialog
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete website'));
        await tester.pumpAndSettle();

        // Confirm deletion
        expect(find.text('Are you sure you want to delete this website?'),
            findsOneWidget);
        await tester.tap(find.text('DELETE WEBSITE'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        verify(mockWebsiteProvider.deleteWebsite(any,
            context: anyNamed('context')));
        expect(find.byType(PortalPage), findsOneWidget);
      });
    }
  });
}
