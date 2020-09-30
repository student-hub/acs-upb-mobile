import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockWebsiteProvider extends Mock implements WebsiteProvider {}

class MockFilterProvider extends Mock implements FilterProvider {}

class MockAuthProvider extends Mock implements AuthProvider {}

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  final WebsiteProvider mockWebsiteProvider = MockWebsiteProvider();
  // ignore: invalid_use_of_protected_member
  when(mockWebsiteProvider.hasListeners).thenReturn(false);
  when(mockWebsiteProvider.fetchWebsites(any)).thenAnswer((_) => Future.value([
        Website(
          id: '1',
          relevance: null,
          category: WebsiteCategory.learning,
          iconPath: 'icons/websites/moodle.png',
          infoByLocale: {'en': 'info-en', 'ro': 'info-ro'},
          label: 'Moodle',
          link: 'http://acs.curs.pub.ro/',
          isPrivate: false,
        ),
        Website(
          id: '2',
          relevance: null,
          category: WebsiteCategory.learning,
          iconPath: 'icons/websites/ocw.png',
          infoByLocale: {},
          label: 'OCW',
          link: 'https://ocw.cs.pub.ro/',
          isPrivate: false,
        ),
        Website(
          id: '3',
          relevance: null,
          category: WebsiteCategory.association,
          iconPath: 'icons/websites/lsac.png',
          infoByLocale: {},
          label: 'LSAC',
          link: 'https://lsacbucuresti.ro/',
          isPrivate: false,
        ),
      ]));

  final FilterProvider mockFilterProvider = MockFilterProvider();
  // ignore: invalid_use_of_protected_member
  when(mockFilterProvider.hasListeners).thenReturn(false);
  when(mockFilterProvider.fetchFilter(any))
      .thenAnswer((_) => Future.value(Filter(root: FilterNode(name: 'All'))));
  when(mockFilterProvider.filterEnabled).thenReturn(true);

  final MockUrlLauncher mockUrlLauncher = MockUrlLauncher();
  UrlLauncherPlatform.instance = mockUrlLauncher;
  when(mockUrlLauncher.canLaunch(any))
      .thenAnswer((realInvocation) => Future.value(true));

  final MockAuthProvider mockAuthProvider = MockAuthProvider();
  // ignore: invalid_use_of_protected_member
  when(mockAuthProvider.hasListeners).thenReturn(false);
  when(mockAuthProvider.isAnonymous).thenReturn(false);
  when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
  when(mockAuthProvider.isAuthenticatedFromService)
      .thenAnswer((realInvocation) => Future.value(true));

  Widget buildPortalPage() => MultiProvider(
        providers: [
          ChangeNotifierProvider<WebsiteProvider>(
              create: (_) => mockWebsiteProvider),
          ChangeNotifierProvider<FilterProvider>(
              create: (_) => mockFilterProvider),
          ChangeNotifierProvider<AuthProvider>(create: (_) => mockAuthProvider),
        ],
        child: const MaterialApp(
          localizationsDelegates: [S.delegate],
          home: PortalPage(),
        ),
      );

  group('Portal', () {
    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      PrefService.enableCaching();
      PrefService.cache = {};
      PrefService.setString('language', 'en');
    });

    testWidgets('Names', (WidgetTester tester) async {
      await tester.pumpWidget(buildPortalPage());
      await tester.pumpAndSettle();

      expect(find.text('Moodle'), findsOneWidget);
      expect(find.text('OCW'), findsOneWidget);
      expect(find.text('LSAC'), findsOneWidget);
    });

    group('Localization', () {
      testWidgets('en', (WidgetTester tester) async {
        await tester.pumpWidget(buildPortalPage());
        await tester.pumpAndSettle();

        expect(find.byTooltip('info-en'), findsOneWidget);
      });

      testWidgets('ro', (WidgetTester tester) async {
        PrefService.setString('language', 'ro');
        await S.load(const Locale('ro', 'RO'));

        await tester.pumpWidget(buildPortalPage());
        await tester.pumpAndSettle();

        expect(find.byTooltip('info-ro'), findsOneWidget);
      });
    });

    testWidgets('Links', (WidgetTester tester) async {
      await tester.pumpWidget(buildPortalPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Moodle'));
      verify(mockUrlLauncher.launch('http://acs.curs.pub.ro/',
              useSafariVC: anyNamed('useSafariVC'),
              useWebView: anyNamed('useWebView'),
              enableDomStorage: anyNamed('enableDomStorage'),
              enableJavaScript: anyNamed('enableJavaScript'),
              universalLinksOnly: anyNamed('universalLinksOnly'),
              headers: anyNamed('headers')))
          .called(1);

      await tester.tap(find.text('OCW'));
      verify(mockUrlLauncher.launch('https://ocw.cs.pub.ro/',
              useSafariVC: anyNamed('useSafariVC'),
              useWebView: anyNamed('useWebView'),
              enableDomStorage: anyNamed('enableDomStorage'),
              enableJavaScript: anyNamed('enableJavaScript'),
              universalLinksOnly: anyNamed('universalLinksOnly'),
              headers: anyNamed('headers')))
          .called(1);

      await tester.tap(find.text('LSAC'));
      verify(mockUrlLauncher.launch('https://lsacbucuresti.ro/',
              useSafariVC: anyNamed('useSafariVC'),
              useWebView: anyNamed('useWebView'),
              enableDomStorage: anyNamed('enableDomStorage'),
              enableJavaScript: anyNamed('enableJavaScript'),
              universalLinksOnly: anyNamed('universalLinksOnly'),
              headers: anyNamed('headers')))
          .called(1);
    });
  });
}
